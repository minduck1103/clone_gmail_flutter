const Mail = require("../models/Mail");

// Get Inbox mails (received mails not in trash or drafts)
exports.getInboxMails = async (req, res) => {
  try {
    //req.user = { phone: "222222222" };
    const mails = await Mail.find({
      recipient: req.user.phone,
      isTrashed: false,
      autoSave: false,
    }).sort({ createdAt: -1 });
    if (!mails || mails.length === 0) {
      return res.status(404).json({ message: "No mails found in inbox" });
    }
    res.status(200).json(mails);
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

// Get Starred mails
exports.getStarredMails = async (req, res) => {
  try {
    const userPhone = req.user.phone;
    
    // Lấy tất cả mail có isStarred = true mà user có liên quan
    const mails = await Mail.find({
      $or: [
        { senderPhone: userPhone },
        { recipient: userPhone }
      ],
      isStarred: true,
      isTrashed: false,
    }).sort({ createdAt: -1 });
    
    if (!mails || mails.length === 0) {
      return res.status(404).json({ message: "No starred mails found" });
    }
    res.status(200).json(mails);
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

// Get Sent mails
exports.getSentMails = async (req, res) => {
  try {
    const mails = await Mail.find({
      createdBy: req.user._id,
      autoSave: false,
      isTrashed: false,
    }).sort({ createdAt: -1 });
    if (!mails || mails.length === 0) {
      return res.status(404).json({ message: "No sent mails found" });
    }
    res.status(200).json(mails);
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

// Get Drafts
exports.getDraftMails = async (req, res) => {
  try {
    const mails = await Mail.find({
      createdBy: req.user._id,
      autoSave: true,
      isTrashed: false,
    }).sort({ createdAt: -1 });
    if (!mails || mails.length === 0) {
      return res.status(404).json({ message: "No draft mails found" });
    }
    res.status(200).json(mails);
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

// Get Trashed mails
exports.getTrashedMails = async (req, res) => {
  try {
    const mails = await Mail.find({
      createdBy: req.user._id,
      isTrashed: true,
    }).sort({ createdAt: -1 });
    if (!mails || mails.length === 0) {
      return res.status(404).json({ message: "No trashed mails found" });
    }
    res.status(200).json(mails);
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

exports.getAllMails = async (req, res) => {
  try {
    const userPhone = req.user.phone;
    
    // Lấy tất cả mail mà user là sender hoặc recipient
    const allMails = await Mail.find({
      $or: [
        { senderPhone: userPhone },
        { recipient: userPhone }
      ]
    }).sort({ createdAt: -1 });

    res.status(200).json(allMails);
  } catch (error) {
    console.error("Error fetching all mails:", error);
    res.status(500).json({ message: "Server error", error: error.message });
  }
};
