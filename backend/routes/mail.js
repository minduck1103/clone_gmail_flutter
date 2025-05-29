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
  updateLabels,
  replyMail,
  forwardMail
} = require("../controllers/mailController");


// Multer config
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "uploads/attachments");
  },
  filename: function (req, file, cb) {
    cb(null, `${Date.now()}-${file.originalname}`);
  },
});

const upload = multer({
  storage,
  limits: { fileSize: 1024 * 1024 * 10 }, // 10MB
  fileFilter: function (req, file, cb) {
    const filetypes = /pdf|doc|docx|jpg|jpeg|png|txt/;
    const mimetype = filetypes.test(file.mimetype);
    const extname = filetypes.test(path.extname(file.originalname).toLowerCase());
    if (mimetype && extname) {
      return cb(null, true);
    }
    cb(new Error("Only accept .pdf, .doc, .docx, .jpg, .jpeg, .png .txt!"));
  },
});

// Routes
router.post("/", upload.array("attachments", 5), createMail);
router.get("/", auth, getMails);
router.get("/:id", auth, getMailById);
router.put("/:id", auth, upload.array("attachments", 5), updateMail);

router.delete("/:id", auth, deleteMail);
router.patch("/:id/star", auth, toggleStarred);
router.patch("/:id/read", auth, toggleRead);
router.patch("/:id/trash", auth, moveToTrash);
//router.patch("/:id/labels", auth, updateLabels);
router.post("/:id/reply", auth, upload.array("attachments", 5), replyMail);
router.post("/:id/forward", auth, upload.array("attachments", 5), forwardMail);


module.exports = router;