const Mail = require("../models/Mail");
const User = require("../models/User");

// Helper function to populate sender and recipient names
const populateMailsWithNames = async (mails) => {
  return await Promise.all(
    mails.map(async (mail) => {
      const sender = await User.findOne({ phone: mail.senderPhone });
      console.log(`Mail ID: ${mail._id}, SenderPhone: ${mail.senderPhone}, SenderName: ${sender?.fullname}`);
      
      // Populate recipient names
      const recipientNames = await Promise.all(
        mail.recipient.map(async (phone) => {
          const user = await User.findOne({ phone });
          return {
            phone,
            name: user ? user.fullname : phone,
          };
        })
      );
      
      return {
        ...mail.toObject(),
        senderName: sender ? sender.fullname : mail.senderPhone,
        recipientNames,
      };
    })
  );
};

// Get Inbox mails (received mails not in trash or drafts)
exports.getInboxMails = async (req, res) => {
  try {
    console.log(`getInboxMails for user: ${req.user.phone}`);
    
    // Debug: try different queries
    const query1 = await Mail.find({ recipient: req.user.phone }).countDocuments();
    const query2 = await Mail.find({ recipient: { $in: [req.user.phone] } }).countDocuments();
    const query3 = await Mail.find({ recipient: { $elemMatch: { $eq: req.user.phone } } }).countDocuments();
    
    console.log(`Query results - exact match: ${query1}, $in: ${query2}, $elemMatch: ${query3}`);
    
    const mails = await Mail.find({
      recipient: { $in: [req.user.phone] },
      isTrashed: false,
      autoSave: false,
    }).sort({ createdAt: -1 });
    
    console.log(`Found ${mails.length} inbox mails`);
    mails.forEach(mail => {
      console.log(`Mail: ${mail._id}, From: ${mail.senderPhone}, To: ${JSON.stringify(mail.recipient)}`);
    });
    
    if (!mails || mails.length === 0) {
      return res.status(404).json({ message: "No mails found in inbox" });
    }

    const mailsWithNames = await populateMailsWithNames(mails);
    res.status(200).json(mailsWithNames);
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

// Get Starred mails
exports.getStarredMails = async (req, res) => {
  try {
    const userPhone = req.user.phone;
    
    // Lấy mail có isStarred = true HOẶC có label "Có gắn dấu sao"
    const mails = await Mail.find({
      $or: [
        { senderPhone: userPhone },
        { recipient: userPhone }
      ],
      $or: [
        { isStarred: true },
        { labels: { $in: ["Có gắn dấu sao"] } }
      ],
      isTrashed: false,
    }).sort({ createdAt: -1 });
    
    if (!mails || mails.length === 0) {
      return res.status(404).json({ message: "No starred mails found" });
    }
    
    const mailsWithNames = await populateMailsWithNames(mails);
    res.status(200).json(mailsWithNames);
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

// Get Sent mails
exports.getSentMails = async (req, res) => {
  try {
    // Lấy mail đã gửi HOẶC có label "Đã gửi"
    const mails = await Mail.find({
      $or: [
        { 
          senderPhone: req.user.phone,
      autoSave: false,
        },
        { 
          senderPhone: req.user.phone,
          labels: { $in: ["Đã gửi"] } 
        }
      ],
      isTrashed: false,
    }).sort({ createdAt: -1 });
    if (!mails || mails.length === 0) {
      return res.status(404).json({ message: "No sent mails found" });
    }
    
    const mailsWithNames = await populateMailsWithNames(mails);
    res.status(200).json(mailsWithNames);
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

// Get Drafts
exports.getDraftMails = async (req, res) => {
  try {
    // Lấy mail nháp HOẶC có label "Thư nháp"
    const mails = await Mail.find({
      $or: [
        { 
      createdBy: req.user._id,
      autoSave: true,
        },
        { 
          $or: [
            { senderPhone: req.user.phone },
            { recipient: req.user.phone }
          ],
          labels: { $in: ["Thư nháp"] } 
        }
      ],
      isTrashed: false,
    }).sort({ createdAt: -1 });
    if (!mails || mails.length === 0) {
      return res.status(404).json({ message: "No draft mails found" });
    }
    
    const mailsWithNames = await populateMailsWithNames(mails);
    res.status(200).json(mailsWithNames);
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

// Get Trashed mails
exports.getTrashedMails = async (req, res) => {
  try {
    // Lấy mail đã xóa HOẶC có label "Thùng rác"
    const mails = await Mail.find({
      $or: [
        { 
      createdBy: req.user._id,
      isTrashed: true,
        },
        { 
          $or: [
            { senderPhone: req.user.phone },
            { recipient: req.user.phone }
          ],
          labels: { $in: ["Thùng rác"] } 
        }
      ]
    }).sort({ createdAt: -1 });
    if (!mails || mails.length === 0) {
      return res.status(404).json({ message: "No trashed mails found" });
    }
    
    const mailsWithNames = await populateMailsWithNames(mails);
    res.status(200).json(mailsWithNames);
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

exports.getAllMails = async (req, res) => {
  try {
    const userPhone = req.user.phone;
    
    // Debug: Show raw mail structure
    const rawMails = await Mail.find({}).sort({ createdAt: -1 }).limit(5);
    console.log("=== RAW MAILS DEBUG ===");
    rawMails.forEach(mail => {
      console.log(`Mail ID: ${mail._id}`);
      console.log(`  SenderPhone: ${mail.senderPhone}`);
      console.log(`  Recipient: ${JSON.stringify(mail.recipient)}`);
      console.log(`  AutoSave: ${mail.autoSave}`);
      console.log(`  IsTrashed: ${mail.isTrashed}`);
      console.log(`---`);
    });
    
    // Lấy tất cả mail mà user là sender hoặc recipient
    const allMails = await Mail.find({
      $or: [
        { senderPhone: userPhone },
        { recipient: userPhone }
      ]
    }).sort({ createdAt: -1 });

    const mailsWithNames = await populateMailsWithNames(allMails);
    res.status(200).json(mailsWithNames);
  } catch (error) {
    console.error("Error fetching all mails:", error);
    res.status(500).json({ message: "Server error", error: error.message });
  }
};

exports.getMailsByLabel = async (req, res) => {
  try {
    const { label } = req.params;
    const userPhone = req.user.phone;
    
    console.log(`getMailsByLabel for user: ${userPhone}, label: ${label}`);
    
    // Lấy mail mà user là sender hoặc recipient và có label cụ thể
    const mails = await Mail.find({
      $or: [
        { senderPhone: userPhone },
        { recipient: { $in: [userPhone] } }
      ],
      labels: { $in: [label] },
      isTrashed: false,
    }).sort({ createdAt: -1 });
    
    console.log(`Found ${mails.length} mails with label: ${label}`);
    
    if (!mails || mails.length === 0) {
      return res.status(404).json({ message: `No mails found with label: ${label}` });
    }

    const mailsWithNames = await populateMailsWithNames(mails);
    res.status(200).json(mailsWithNames);
  } catch (error) {
    res.status(500).json({ message: "Server error", error: error.message });
  }
};
