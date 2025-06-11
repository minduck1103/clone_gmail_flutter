const express = require("express");
const router = express.Router();
const auth = require("../middleware/auth");
const multer = require("multer");
const path = require("path");

const {
  createMail,
  getMails,
  getMailById,
  updateMail,
  deleteMail,
  toggleStarred,
  toggleRead,
  moveToTrash,
  replyMail,
  forwardMail,
  updateLabels,
  // getMailBySearch,
} = require("../controllers/mailController");

const{
  getInboxMails,
  getSentMails,
  getDraftMails,
  getTrashedMails,
  getStarredMails,
  getAllMails,
  getMailsByLabel
} = require("../controllers/getMailsController");

// Multer config
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "uploads/attachments");
  },
  filename: function (req, file, cb) {
    // Clean filename to avoid encoding issues
    const cleanName = file.originalname
      .replace(/[^\w\-_.]/g, '_')  // Replace special chars with underscore
      .replace(/_{2,}/g, '_');     // Replace multiple underscores with single
    
    const timestamp = Date.now();
    const ext = path.extname(file.originalname);
    const nameWithoutExt = path.basename(file.originalname, ext);
    
    // Create safe filename: timestamp-cleanname.ext
    const safeFilename = `${timestamp}-${nameWithoutExt.replace(/[^\w\-]/g, '_')}${ext}`;
    
    console.log("Original filename:", file.originalname);
    console.log("Safe filename:", safeFilename);
    
    cb(null, safeFilename);
  },
});

const upload = multer({
  storage,
  limits: { fileSize: 1024 * 1024 * 10 }, // 10MB
  fileFilter: function (req, file, cb) {
    console.log("Checking file:", file.originalname, "MIME:", file.mimetype);
    
    // Allow based on file extension
    const extname = path.extname(file.originalname).toLowerCase();
    const allowedExtensions = ['.pdf', '.doc', '.docx', '.jpg', '.jpeg', '.png', '.txt'];
    
    if (allowedExtensions.includes(extname)) {
      console.log("File accepted:", extname);
      return cb(null, true);
    }
    
    console.log("File rejected:", extname);
    cb(new Error("Only accept .pdf, .doc, .docx, .jpg, .jpeg, .png, .txt files!"));
  },
});

// Routes
router.post("/", auth, upload.array("attachments", 5), createMail);
router.get("/", auth, getMails);
router.get("/:id", auth, getMailById);
router.put("/:id", auth, upload.array("attachments", 5), updateMail);

router.delete("/:id", auth, deleteMail);
router.patch("/:id/star", auth, toggleStarred);
router.patch("/:id/read", auth, toggleRead);
router.patch("/:id/trash", auth, moveToTrash);
router.patch("/:id/labels", auth, updateLabels);
router.post("/:id/reply", auth, upload.array("attachments", 5), replyMail);
router.post("/:id/forward", auth, upload.array("attachments", 5), forwardMail);

router.get("/user/inbox", auth, getInboxMails);
router.get("/user/sent", auth, getSentMails);
router.get("/user/drafts", auth, getDraftMails);
router.get("/user/trash", auth, getTrashedMails);
router.get("/user/starred", auth, getStarredMails);
router.get("/user/all", auth, getAllMails);
router.get("/user/label/:label", auth, getMailsByLabel);


module.exports = router;