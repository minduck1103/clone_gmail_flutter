const Mail = require("../models/Mail");
const User = require("../models/User");

exports.createMail = async (req, res) => {
  try {
    // req.user = {
    //   id: "68303019f9614c4478acabc6",
    //   phone: "111111111", // or any test number
    // };
    const { recipient, cc, bcc, title, content, autoSave } = req.body;

    // Validate required fields
    if (!recipient || !title || !content) {
      return res
        .status(400)
        .json({ message: "Recipient, title, and content are required." });
    }

    // Check if req.user and req.user.id exist
    if (!req.user || !req.user.id) {
      return res.status(401).json({ message: "User authentication required." });
    }

    // Handle uploaded attachments
    const attachments = req.files
      ? req.files.map((file) => `/uploads/attachments/${file.filename}`)
      : [];

    // Create new mail instance
    const newMail = new Mail({
      senderPhone: req.user.phone, // Assuming phone is stored in req.user
      recipient: Array.isArray(recipient) ? recipient : [recipient],
      cc: cc ? [].concat(cc) : [],
      bcc: bcc ? [].concat(bcc) : [],
      title,
      content,
      attach: attachments,
      autoSave: autoSave === "true" || autoSave === true,
      createdBy: req.user.id,
    });

    await newMail.save();

    // Check for auto-reply settings in recipients
    const recipientsArray = Array.isArray(recipient) ? recipient : [recipient];

    const usersToAutoReply = await User.find({
      phone: { $in: recipientsArray },
      "preferences.autoAnswer": true,
    });

    for (const user of usersToAutoReply) {
      const autoReply = new Mail({
        senderPhone: user.phone, // Auto-responder is the recipient
        recipient: [req.user.phone], // Send back to original sender
        title: `Re: ${title}`,
        content: user.preferences?.autoAnswerMessage || "I'm currently unavailable.",
        createdBy: user._id,
        replyTo: newMail._id,
      });
      await autoReply.save();
    }

    res
      .status(201)
      .json({ message: "Mail created successfully", mail: newMail });
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

exports.getMails = async (req, res) => {
  try {
    const mails = await Mail.find().sort({ createdAt: -1 });
    res.status(200).json(mails);
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

//View metadata of a specific mail by ID
exports.getMailById = async (req, res) => {
  try {
    const mail = await Mail.findById(req.params.id);
    if (!mail) {
      return res.status(404).json({ message: "Mail not found" });
    }
    res.status(200).json(mail);
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

exports.updateMail = async (req, res) => {
  try {
    const { id } = req.params;
    const { recipient, cc, bcc, title, content, autoSave } = req.body;

    // Validate required fields
    if (!recipient || !title || !content) {
      return res
        .status(400)
        .json({ message: "Recipient, title, and content are required." });
    }

    // Handle uploaded attachments
    const attachments = req.files
      ? req.files.map((file) => `/uploads/attachments/${file.filename}`)
      : [];

    // Update mail instance
    const updatedMail = await Mail.findByIdAndUpdate(
      id,
      {
        recipient: Array.isArray(recipient) ? recipient : [recipient],
        cc: cc ? [].concat(cc) : [],
        bcc: bcc ? [].concat(bcc) : [],
        title,
        content,
        attach: attachments,
        autoSave: autoSave === "true" || autoSave === true,
      },
      { new: true }
    );

    if (!updatedMail) {
      return res.status(404).json({ message: "Mail not found" });
    }

    res
      .status(200)
      .json({ message: "Mail updated successfully", mail: updatedMail });
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

exports.deleteMail = async (req, res) => {
  try {
    const { id } = req.params;
    const deletedMail = await Mail.findByIdAndDelete(id);

    if (!deletedMail) {
      return res.status(404).json({ message: "Mail not found" });
    }

    res.status(200).json({ message: "Mail deleted successfully" });
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

exports.toggleRead = async (req, res) => {
  try {
    const mail = await Mail.findByIdAndUpdate(
      req.params.id,
      { isRead: req.body.isRead },
      { new: true }
    );
    res.status(200).json(mail);
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

exports.toggleStarred = async (req, res) => {
  try {
    const mail = await Mail.findByIdAndUpdate(
      req.params.id,
      { isStarred: req.body.isStarred },
      { new: true }
    );
    res.status(200).json(mail);
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

exports.moveToTrash = async (req, res) => {
  try {
    const mail = await Mail.findByIdAndUpdate(
      req.params.id,
      { isTrashed: true },
      { new: true }
    );
    res.status(200).json(mail);
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

//reply mail
exports.replyMail = async (req, res) => {
  try {
    const { id } = req.params;
    const { content } = req.body;

    if (!content) {
      return res
        .status(400)
        .json({ message: "Content is required for reply." });
    }

    const originalMail = await Mail.findById(id);
    if (!originalMail) {
      return res.status(404).json({ message: "Original mail not found." });
    }

    const replyMail = new Mail({
      recipient: originalMail.recipient,
      cc: originalMail.cc,
      bcc: originalMail.bcc,
      title: `Re: ${originalMail.title}`,
      content,
      autoSave: false,
      replyTo: id, // Reference to the original mail
      createdBy: req.user.id,
      attach: req.files
        ? req.files.map((file) => `/uploads/attachments/${file.filename}`)
        : [],
    });

    const savedReply = await replyMail.save();

    // Populate the replyTo field with full original mail details
    const populatedReply = await Mail.findById(savedReply._id).populate(
      "replyTo"
    );

    res.status(201).json({
      message: "Reply sent successfully",
      mail: populatedReply,
    });
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

// Forward mail
exports.forwardMail = async (req, res) => {
  try {
    const { id } = req.params;
    const { recipient, content } = req.body;

    if (!recipient || !content) {
      return res.status(400).json({
        message: "Recipient and content are required for forwarding.",
      });
    }

    // Find the original mail
    const originalMail = await Mail.findById(id);
    if (!originalMail) {
      return res.status(404).json({ message: "Original mail not found." });
    }

    // Create forwarded mail
    const forwardMail = new Mail({
      recipient: Array.isArray(recipient) ? recipient : [recipient],
      cc: originalMail.cc,
      bcc: originalMail.bcc,
      title: `Fwd: ${originalMail.title}`,
      content,
      autoSave: false,
      forwardFrom: id, // Link to original mail
      createdBy: req.user.id,
      attach: originalMail.attach, // Include original attachments
    });

    // Save the new mail
    const savedForwardMail = await forwardMail.save();

    // Populate the forwardFrom field with full mail info
    const populatedMail = await Mail.findById(savedForwardMail._id).populate(
      "forwardFrom"
    );

    res.status(201).json({
      message: "Mail forwarded successfully",
      mail: populatedMail,
    });
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};
