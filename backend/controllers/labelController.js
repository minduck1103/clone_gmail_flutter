const User = require("../models/User");
const Mail = require("../models/Mail");

// get labels for user
exports.getLabels = async (req, res) => {
  try {
    //req.user = { _id: "683800d15345561749af6b8a" };
    const userId = req.user._id; // Assuming user ID is stored in req.user

    const user = await User.findById(userId).select("labels");

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    res.status(200).json({ labels: user.labels });
  } catch (error) {
    res.status(500).json({ message: "Internal server error" });
  }
};

//add label to user
exports.addLabel = async (req, res) => {
  try {
    //req.user = { _id: "683800d15345561749af6b8a" };
    const userId = req.user._id; // Assuming user ID is stored in req.user
    const { labelName } = req.body;

    if (!labelName) {
      return res.status(400).json({ message: "Label name is required" });
    }

    const user = await User.findById(userId).select("labels");

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    if (user.labels.includes(labelName)) {
      return res.status(400).json({ message: "Label already exists" });
    }

    user.labels.push(labelName);
    await user.save();

    res.status(201).json({ labels: user.labels });
  } catch (error) {
    res.status(500).json({ message: "Internal server error" });
  }
};

// Rename label for user
exports.renameLabel = async (req, res) => {
  try {
    //req.user = { _id: "683800d15345561749af6b8a" };
    const userId = req.user._id;
    const { oldName, newName } = req.body;
    if (!oldName || !newName)
      return res
        .status(400)
        .json({ message: "Both old and new names are required" });

    const user = await User.findById(userId);
    if (!user) return res.status(404).json({ message: "User not found" });

    const index = user.labels.indexOf(oldName);
    if (index === -1)
      return res.status(400).json({ message: "Old label not found" });

    // Replace old name
    user.labels[index] = newName;
    await user.save();

    // Rename label in all mails
    await Mail.updateMany(
      { createdBy: userId, labels: oldName },
      { $set: { "labels.$": newName } }
    );

    res.status(200).json({ labels: user.labels });
  } catch (error) {
    res.status(500).json({ message: "Internal server error" });
  }
};

// Delete label for user
exports.deleteLabel = async (req, res) => {
  try {
    //req.user = { _id: "683800d15345561749af6b8a" };
    const userId = req.user._id;
    const { labelName } = req.body;

    if (!labelName) {
      return res.status(400).json({ message: "Label name is required" });
    }

    // Fetch user first
    const user = await User.findById(userId).select("labels");
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    // Check if label exists
    if (!user.labels.includes(labelName)) {
      return res.status(400).json({ message: "Label not found" });
    }

    // Remove the label from user's labels
    const updatedUser = await User.findByIdAndUpdate(
      userId,
      { $pull: { labels: labelName } },
      { new: true, select: "labels" }
    );

    // Remove the label from all mails
    await Mail.updateMany(
      { createdBy: userId },
      { $pull: { labels: labelName } }
    );

    res.status(200).json({ labels: updatedUser.labels });
  } catch (error) {
    res.status(500).json({ message: "Internal server error" });
  }
};

// Add label to a mail
exports.addLabelToMail = async (req, res) => {
  try {
    //req.user = { _id: "683800d15345561749af6b8a" };
    const userId = req.user._id;
    const mailId = req.params.id; // Assuming mail ID is passed in the URL
    const { labelName } = req.body;

    if (!mailId || !labelName) {
      return res
        .status(400)
        .json({ message: "mailId and labelName are required" });
    }

    const user = await User.findById(userId);
    if (!user || !user.labels.includes(labelName)) {
      return res
        .status(400)
        .json({ message: "Label does not exist for this user" });
    }

    const updatedMail = await Mail.findOneAndUpdate(
      { _id: mailId, createdBy: userId },
      { $addToSet: { labels: labelName } },
      { new: true }
    );

    if (!updatedMail) {
      return res
        .status(404)
        .json({ message: "Mail not found or unauthorized" });
    }

    res
      .status(200)
      .json({ message: "Label added to mail", labels: updatedMail.labels });
  } catch (error) {
    res.status(500).json({ message: "Internal server error" });
  }
};

// Remove label from a mail
exports.removeLabelFromMail = async (req, res) => {
  try {
    //req.user = { _id: "683800d15345561749af6b8a" };
    const userId = req.user._id;
    const mailId = req.params.id; // Assuming mail ID is passed in the URL
    const { labelName } = req.body;

    if (!mailId || !labelName) {
      return res
        .status(400)
        .json({ message: "mailId and labelName are required" });
    }

    const updatedMail = await Mail.findOneAndUpdate(
      { _id: mailId, createdBy: userId },
      { $pull: { labels: labelName } },
      { new: true }
    );

    if (!updatedMail) {
      return res
        .status(404)
        .json({ message: "Mail not found or unauthorized" });
    }

    res
      .status(200)
      .json({ message: "Label removed from mail", labels: updatedMail.labels });
  } catch (error) {
    res.status(500).json({ message: "Internal server error" });
  }
};

// Get mails filtered by label
exports.getMailsByLabel = async (req, res) => {
  try {
    //req.user = { _id: "683800d15345561749af6b8a" };
    const userId = req.user._id;
    const labelName = req.params.label;

    if (!labelName) {
      return res.status(400).json({ message: "Label name is required" });
    }

    const mails = await Mail.find({
      createdBy: userId,
      labels: labelName,
    }).sort({ createdAt: -1 }); 

    res.status(200).json({ mails });
  } catch (error) {
    res.status(500).json({ message: "Internal server error" });
  }
};
