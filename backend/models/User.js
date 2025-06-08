const mongoose = require("mongoose");
const bcrypt = require("bcrypt");

const userSchema = new mongoose.Schema(
  {
    fullname: { type: String, required: true, trim: true },
    phone: { type: String, required: true, trim: true, unique: true },
    password: { type: String, required: true, minlength: 6 },
    profileImage: { type: String, default: "" },
    role: { type: String, enum: ["user", "admin"], default: "user" },
    twoFactorEnabled: { type: Boolean, default: false },
    resetPasswordToken: String,
    resetPasswordExpires: Date,
    labels: { type: [String], default: [] },

    preferences: {
      notifications: { type: Boolean, default: true },
      fontSize: {
        type: String,
        enum: ["small", "medium", "large"],
        default: "medium",
      },
      fontFamily: { type: String, default: "Arial" },
      theme: { type: String, enum: ["light", "dark"], default: "light" },
      autoAnswer: { type: Boolean, default: false },
      autoAnswerMessage: { type: String, default: "Thank you for your message. I will get back to you soon." },
    },
    createdAt: { type: Date, default: Date.now },
    updatedAt: { type: Date, default: Date.now },
  },
  {
    timestamps: true,
  }
);

// Combined pre-save hook for timestamp and password hashing
userSchema.pre("save", async function (next) {
  try {
    // Update timestamp
    this.updatedAt = Date.now();
    
    // Only hash the password if it has been modified (or is new)
    if (this.isModified("password") && this.password) {
      console.log('Hashing password for user:', this.phone);
      const salt = await bcrypt.genSalt(12);
      const hashedPassword = await bcrypt.hash(this.password, salt);
      this.password = hashedPassword;
      console.log('Password hashed successfully');
    }
    next();
  } catch (error) {
    console.error("Pre-save hook error:", error);
    next(error);
  }
});

// Method to compare password
userSchema.methods.comparePassword = async function (candidatePassword) {
  try {
    const isMatch = await bcrypt.compare(candidatePassword, this.password);
    //console.log('Password comparison result:', isMatch);
    return isMatch;
  } catch (error) {
    console.error("Password comparison error:", error);
    return false;
  }
};

module.exports = mongoose.model("User", userSchema);
