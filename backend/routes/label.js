const express = require("express");
const router = express.Router();
const auth = require("../middleware/auth");

const {
  getLabels,
  addLabel,
  renameLabel,
  deleteLabel,
  addLabelToMail,
  removeLabelFromMail,
  getMailsByLabel
} = require("../controllers/labelController");

//Routes
router.get("/", auth, getLabels); // Get labels for user
router.post("/",auth,  addLabel); // Add label to user
router.put("/", auth, renameLabel); // Rename label for user
router.delete("/",auth,  deleteLabel); // Delete label for user
router.post("/mail/:id",auth,  addLabelToMail); // Add label to mail
router.delete("/mail/:id", auth, removeLabelFromMail); // Remove label from mail
router.get("/mail/:label",auth,  getMailsByLabel); // Get mails by label

module.exports = router;
