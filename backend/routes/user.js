const express = require("express");
const router = express.Router();
const auth = require("../middleware/auth");
const multer = require("multer");
const path = require("path");

const {
  getAccount,
  updateAccount,
  uploadAvatar,
  toggle2FA,
} = require("../controllers/userController");

const { getUserPreferences, updateUserPreferences } = require("../controllers/userPreferenceController");

// Multer config
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "uploads/profile");
  },
  filename: function (req, file, cb) {
    cb(null, `${Date.now()}-${file.originalname}`);
  },
});

const upload = multer({
  storage,
  limits: { fileSize: 1024 * 1024 * 5 }, // 5MB
  fileFilter: function (req, file, cb) {
    const filetypes = /jpeg|jpg|png/;
    const mimetype = filetypes.test(file.mimetype);
    const extname = filetypes.test(path.extname(file.originalname).toLowerCase());
    if (mimetype && extname) {
      return cb(null, true);
    }
    cb(new Error("Only accept .png, .jpg .jpeg!"));
  },
});

// Routes
router.get("/account", auth, getAccount);
router.put("/account", auth, updateAccount);
router.post("/avatar", auth, upload.single("avatar"), uploadAvatar);
router.put("/2fa", auth, toggle2FA);
router.get("/preferences/:userId", auth, getUserPreferences);
router.put("/preferences/:userId", auth, updateUserPreferences);

module.exports = router;
