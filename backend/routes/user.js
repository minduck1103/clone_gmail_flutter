const express = require("express");
const router = express.Router();
const bcrypt = require("bcryptjs");
const auth = require("../middleware/auth");
const User = require("../models/User");
const multer = require("multer");
const path = require("path");
const fs = require("fs");
//const isAdmin = require('../middleware/isAdmin');

// Configure multer for file upload
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "uploads/profile");
  },
  filename: function (req, file, cb) {
    cb(null, `${Date.now()}-${file.originalname}`);
  },
});

const upload = multer({
  storage: storage,
  limits: { fileSize: 1024 * 1024 * 5 }, // 5MB limit
  fileFilter: function (req, file, cb) {
    const filetypes = /jpeg|jpg|png/;
    const mimetype = filetypes.test(file.mimetype);
    const extname = filetypes.test(
      path.extname(file.originalname).toLowerCase()
    );

    if (mimetype && extname) {
      return cb(null, true);
    }
    cb(new Error("Chỉ chấp nhận file .png, .jpg và .jpeg!"));
  },
});

// Get user account info
router.get("/account", auth, async (req, res) => {
  try {
    const user = await User.findById(req.user.id).select("-password");
    if (!user) {
      return res.status(404).json({ message: "Cannot find user" });
    }
    res.json(user);
  } catch (error) {
    res.status(500).json({ message: "Server error" });
  }
});

// Update user account info
router.put("/account",auth, async (req, res) => {
  try {
    const { fullname, phone, email } = req.body;
    const user = await User.findById(req.user.id);
    //const user = await User.findById("6831461be665b1eb6e30af5b");
    if (!user) {
      return res.status(404).json({ message: "Cannot find user" });
    }

    user.fullname = fullname || user.fullname;
    user.phone = phone || user.phone;
    user.email = email || user.email;

    await user.save();

    //Return user
    const updatedUser = await User.findById(user.id).select("-password");
    res.json({ user: updatedUser, message: "User updated successfully" });
  } catch (error) {
    res.status(500).json({ message: "Server error" });
  }
});

//upload avatar
router.post("/avatar",auth, upload.single("avatar"), async (req, res) => {
  try {
    //const user = await User.findById(req.user.id);
    const user = await User.findById("6831461be665b1eb6e30af5b");
    if (!user) {
      return res.status(404).json({ message: "Cannot find user" });
    }
    // Delete old avatar if exists
    if (user.avatar) {
      const oldImagePath = path.join(__dirname, '..', user.avatar);
      if (fs.existsSync(oldImagePath)) {
        fs.unlinkSync(oldImagePath);
      }
    }
    // Update user avatar
    user.avatar = `/uploads/profile/${req.file.filename}`;
    await user.save();
    res.json({ message: "Avatar uploaded successfully", avatar: user.avatar });
  } catch (error) {
    res.status(500).json({ message: "Server error" });
  }
});

//enable or disable two-factor authentication
router.put("/2fa", auth, async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    if (!user) {
      return res.status(404).json({ message: "Cannot find user" });
    }

    user.twoFactorEnabled = !user.twoFactorEnabled;
    await user.save();

    res.json({
      message: `Two-factor authentication ${user.twoFactorEnabled ? 'enabled' : 'disabled'} successfully`,
      twoFactorEnabled: user.twoFactorEnabled,
    });
  } catch (error) {
    res.status(500).json({ message: "Server error" });
  }
});

module.exports = router;
