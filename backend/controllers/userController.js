const User = require("../models/User");
const path = require("path");
const fs = require("fs");

exports.getAccount = async (req, res) => {
  try {
    const user = await User.findById(req.user.id).select("-password");
    //const user = await User.findById("683800d15345561749af6b8a");
    if (!user) return res.status(404).json({ message: "Cannot find user" });
    res.json(user);
  } catch (error) {
    res.status(500).json({ message: "Server error" });
  }
};

exports.updateAccount = async (req, res) => {
  try {
    const { fullname, phone } = req.body;
    const user = await User.findById(req.user.id);
    if (!user) return res.status(404).json({ message: "Cannot find user" });

    user.fullname = fullname || user.fullname;
    user.phone = phone || user.phone;
    //user.email = email || user.email;

    await user.save();

    const updatedUser = await User.findById(user.id).select("-password");
    res.json({ user: updatedUser, message: "User updated successfully" });
  } catch (error) {
    res.status(500).json({ message: "Server error" });
  }
};

exports.uploadAvatar = async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    if (!user) return res.status(404).json({ message: "Cannot find user" });

    // Delete old avatar if exists
    if (user.avatar) {
      const oldImagePath = path.join(__dirname, "..", user.avatar);
      if (fs.existsSync(oldImagePath)) {
        fs.unlinkSync(oldImagePath);
      }
    }

    user.avatar = `/uploads/profile/${req.file.filename}`;
    await user.save();

    res.json({ message: "Avatar uploaded successfully", avatar: user.avatar });
  } catch (error) {
    res.status(500).json({ message: "Server error" });
  }
};

exports.toggle2FA = async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    if (!user) return res.status(404).json({ message: "Cannot find user" });

    user.twoFactorEnabled = !user.twoFactorEnabled;
    await user.save();

    res.json({
      message: `Two-factor authentication ${user.twoFactorEnabled ? "enabled" : "disabled"} successfully`,
      twoFactorEnabled: user.twoFactorEnabled,
    });
  } catch (error) {
    res.status(500).json({ message: "Server error" });
  }
};
