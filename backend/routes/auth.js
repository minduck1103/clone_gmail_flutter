const express = require("express");
const router = express.Router();
const bcrypt = require("bcryptjs");
const { body, validationResult } = require("express-validator");
const User = require("../models/User");
const crypto = require("crypto");
const config = require("../config/main");
const jwt = require("jsonwebtoken");
const auth = require("../middleware/auth");

const validateRegistration = [
  body("phone").notEmpty().isInt().withMessage("Please input phone number"),
  body("fullname").notEmpty().withMessage("Please input full name"),
  body("password").notEmpty().withMessage("Please input password"),
];

//Register a new user
router.post("/register", validateRegistration, async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { phone, fullname, password } = req.body;

    let user = await User.findOne({ phone });
    if (user) {
      return res
        .status(400)
        .json({ message: "this phone number is already registered" });
    }

    //create new user
    user = new User({
      phone,
      fullname,
      password,
    });

    await user.save();
    res.status(201).json({ message: "User registered successfully" });
  } catch (error) {
    res.status(500).json({ message: "Server error" });
  }
});

//Login user
router.post(
  "/login",
  [body("phone").notEmpty().withMessage("Please input phone number")],
  [body("password").exists().notEmpty().withMessage("Please input password")],
  async (req, res) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
      }
      const { phone, password } = req.body;
      // Check if user exists
      let user = await User.findOne({ phone });
      if (!user) {
        return res
          .status(400)
          .json({ message: "Invalid phone number or password" });
      }

      // Check password
      const isMatch = await bcrypt.compare(password, user.password);
      if (!isMatch) {
        return res
          .status(400)
          .json({ message: "Invalid phone number or password" });
      }

      // Generate JWT token
      const payload = { userId: user.id };
      // if (user.email) {
      //   payload.email = user.email;
      // }
      const token = jwt.sign(payload, config.jwtSecret, { expiresIn: "1h" });
      console.log("Token generated:", token);
      res.json({
        token,
        user: { id: user.id, phone: user.phone, fullname: user.fullname },
      });
    } catch (error) {
      return res.status(500).json({ message: "Server error" });
    }
  }
);

//logout user
router.post("/logout", auth, async (req, res) => {
  try {
    // Invalidate the token by removing it from the client side
    req.session = null;
    res.json({ message: "Logged out successfully" });
  } catch (error) {
    return res.status(500).json({ message: "Server error" });
  }
});

//forgot password
router.post(
  "/forgot-password",
  [body("phone").notEmpty().withMessage("Please input phone number")],
  async (req, res) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
      }

      const { phone } = req.body;

      // Check if user exists
      let user = await User.findOne({ phone });
      if (!user) {
        return res.status(400).json({ message: "User not found" });
      }

      // Generate reset token
      const resetToken = crypto.randomBytes(32).toString("hex");
      user.resetToken = resetToken;
      user.resetTokenExpiration = Date.now() + 3600000; // 1 hour
      await user.save();

      // Send email with reset link (pseudo code)
      // sendEmail(user.email, `Reset your password: ${resetToken}`);

      res.json({ message: "Reset link sent to your email" });
    } catch (error) {
      return res.status(500).json({ message: "Server error" });
    }
  }
);

//reset password
router.post(
  "/reset-password/:token",
  [body("newPassword").notEmpty().withMessage("Please input new password")],
  async (req, res) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
      }

      const user = await User.findOne({
        resetPasswordToken: req.params.token,
        resetPasswordExpires: { $gt: Date.now() },
      });

      if (!user) {
        return res
          .status(400)
          .json({ message: "Password reset token is invalid or has expired" });
      }

      const salt = await bcrypt.genSalt(32);
      user.password = await bcrypt.hash(req.body.password, salt);
      user.resetPasswordToken = undefined;
      user.resetPasswordExpires = undefined;
      await user.save();

      res.json({ message: "Password has been reset" });
    } catch (error) {
      return res.status(500).json({ message: "Server error" });
    }
  }
);

//update password
router.post(
  "/update-password",
  auth,
  [body("newPassword").notEmpty().withMessage("Please input new password")],
  async (req, res) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
      }
      const { password, newPassword } = req.body;
      const user = await User.findById(req.user.id);

      if (!user) {
        return res.status(400).json({ message: "User not found" });
      }

      // Check current password
      const isMatch = await bcrypt.compare(password, user.password);
      if (!isMatch) {
        return res
          .status(400)
          .json({ message: "Current password is incorrect" });
      }

      const salt = await bcrypt.genSalt(32);
      user.password = await bcrypt.hash(newPassword, salt);
      await user.save();

      res.json({ message: "Password updated successfully" });
    } catch (error) {
      return res.status(500).json({ message: "Server error" });
    }
  }
);

module.exports = router;
