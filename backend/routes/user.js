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
    console.log('File filter - Original name:', file.originalname);
    console.log('File filter - MIME type:', file.mimetype);
    console.log('File filter - Field name:', file.fieldname);
    
    // Accept common image types
    const allowedMimeTypes = [
      'image/jpeg',
      'image/jpg', 
      'image/png',
      'image/gif',
      'image/webp'
    ];
    
    const allowedExtensions = /\.(jpg|jpeg|png|gif|webp)$/i;
    
    const mimetypeValid = allowedMimeTypes.includes(file.mimetype);
    const extValid = allowedExtensions.test(file.originalname);
    
    console.log('MIME type valid:', mimetypeValid);
    console.log('Extension valid:', extValid);
    
    if (mimetypeValid || extValid) {
      console.log('File accepted');
      return cb(null, true);
    }
    
    console.log('File rejected - invalid format');
    cb(new Error(`Only accept image files (.png, .jpg, .jpeg, .gif, .webp). Received: ${file.mimetype}`));
  },
});

// Routes
router.get("/account", auth, getAccount);
router.put("/account", auth, updateAccount);
router.post("/avatar", auth, (req, res, next) => {
  console.log('Avatar upload route hit');
  
  // Use multer with error handling
  upload.single("avatar")(req, res, function (err) {
    if (err) {
      console.log('Multer error:', err.message);
      return res.status(400).json({ 
        message: err.message,
        error: "File upload failed",
        supportedFormats: [".jpg", ".jpeg", ".png", ".gif", ".webp"]
      });
    }
    
    console.log('File received:', req.file);
    console.log('User:', req.user);
    uploadAvatar(req, res, next);
  });
});
router.put("/2fa", auth, toggle2FA);
router.get("/preferences/:userId", auth, getUserPreferences);
router.put("/preferences/:userId", auth, updateUserPreferences);

module.exports = router;
