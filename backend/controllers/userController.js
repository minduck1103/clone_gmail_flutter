const User = require("../models/User");
const path = require("path");
const fs = require("fs");

exports.getAccount = async (req, res) => {
  try {
    const user = await User.findById(req.user._id).select("-password");
    //const user = await User.findById("683800d15345561749af6b8a");
    if (!user) return res.status(404).json({ message: "Cannot find user" });
    
    // Convert profileImage path to full URL if exists
    const userObject = user.toObject();
    if (userObject.profileImage && !userObject.profileImage.startsWith('http')) {
      const baseUrl = `${req.protocol}://${req.get('host')}`;
      userObject.profileImage = `${baseUrl}${userObject.profileImage}`;
    }
    
    res.json(userObject);
  } catch (error) {
    console.error('Get account error:', error);
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

exports.updateAccount = async (req, res) => {
  try {
    const { fullname, phone } = req.body;
    const user = await User.findById(req.user._id);
    if (!user) return res.status(404).json({ message: "Cannot find user" });

    user.fullname = fullname || user.fullname;
    user.phone = phone || user.phone;
    //user.email = email || user.email;

    await user.save();

    const updatedUser = await User.findById(user._id).select("-password");
    res.json({ user: updatedUser, message: "User updated successfully" });
  } catch (error) {
    res.status(500).json({ message: "Server error" });
  }
};

exports.uploadAvatar = async (req, res) => {
  try {
    console.log('Upload avatar request received');
    console.log('User ID:', req.user._id);
    console.log('File info:', req.file);
    console.log('Request body:', req.body);
    console.log('Request headers:', req.headers);

    if (!req.file) {
      console.log('No file uploaded - possibly rejected by filter');
      return res.status(400).json({ 
        message: "No file uploaded or file format not supported",
        supportedFormats: [".jpg", ".jpeg", ".png", ".gif", ".webp"]
      });
    }

    const user = await User.findById(req.user._id);
    if (!user) {
      console.log('User not found');
      return res.status(404).json({ message: "Cannot find user" });
    }

    // Delete old avatar if exists
    if (user.profileImage) {
      const oldImagePath = path.join(__dirname, "..", user.profileImage);
      if (fs.existsSync(oldImagePath)) {
        try {
        fs.unlinkSync(oldImagePath);
          console.log('Old avatar deleted:', oldImagePath);
        } catch (deleteErr) {
          console.log('Error deleting old avatar:', deleteErr);
        }
      }
    }

    user.profileImage = `/uploads/profile/${req.file.filename}`;
    await user.save();

    console.log('Avatar uploaded successfully:', user.profileImage);
    
    // Convert to full URL
    const baseUrl = `${req.protocol}://${req.get('host')}`;
    const fullAvatarUrl = `${baseUrl}${user.profileImage}`;
    
    res.json({ 
      message: "Avatar uploaded successfully", 
      avatar: fullAvatarUrl,
      profileImage: fullAvatarUrl
    });
  } catch (error) {
    console.error('Upload avatar error:', error);
    res.status(500).json({ 
      message: "Server error", 
      error: error.message,
      details: error.stack 
    });
  }
};

exports.toggle2FA = async (req, res) => {
  try {
    const user = await User.findById(req.user._id);
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
