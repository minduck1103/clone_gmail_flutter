const User = require("../models/User");

// Get user preferences
exports.getUserPreferences = async (req, res) => {
  try {
    const { userId } = req.params;

    // Find user and return preferences
    const user = await User.findById(userId).select('preferences');

    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    res.status(200).json({
      message: "User preferences retrieved successfully",
      preferences: user.preferences,
    });
  } catch (error) {
    //console.error("Error retrieving user preferences:", error);
    res.status(500).json({ message: "Server error", error: error.message });
  }
}

// Update user preferences
exports.updateUserPreferences = async (req, res) => {
  try {
    const { userId } = req.params;
    const { preferences } = req.body;

    // Validate input
    if (!preferences || typeof preferences !== 'object') {
      return res.status(400).json({ message: "Invalid preferences data" });
    }

    // Find user and update preferences
    const updatedUser = await User.findByIdAndUpdate(
      userId,
      { $set: { preferences } },
      { new: true, runValidators: true }
    );

    if (!updatedUser) {
      return res.status(404).json({ message: "User not found" });
    }

    res.status(200).json({
      message: "User preferences updated successfully",
      user: updatedUser,
    });
  } catch (error) {
    //console.error("Error updating user preferences:", error);
    res.status(500).json({ message: "Server error", error: error.message });
  }
}

