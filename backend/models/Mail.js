const mongoose = require("mongoose");

const MailSchema = new mongoose.Schema(
  {
    recipient: { type: [String], required: true },
    cc: { type: [String], default: [] },
    bcc: { type: [String], default: [] },
    title: { type: String, required: true },
    content: { type: String, required: true },
    attach: { type: [String], default: [] },
    autoSave: { type: Boolean, default: true }, // Default to true for auto-saving drafts
    isRead: { type: Boolean, default: false },
    isStarred: { type: Boolean, default: false },
    labels: { type: [String], default: [] },
    isTrashed: { type: Boolean, default: false },
    replyTo: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Mail',
      default: null
    },
    forwardFrom: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Mail',
      default: null
    },
    createdAt: { type: Date, default: Date.now },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Mail", MailSchema);
