const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

const userSchema = new mongoose.Schema({
  email: {
    type: String,
    trim: true,
    lowercase: true,
    default: '',
    validate: {
      validator: function(v) {
      return v === '' || /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/.test(v);
    },
    message: props => `${props.value} is not a valid email!`
  }
  },
  fullname: {
    type: String,
    required: true,
    trim: true
  },
  phone: {
    type: String,
    trim: true,
    required: true,
    unique: true,
  },
  password: {
    type: String,
    required: true,
    minlength: 6,
  },
//   addresses: [{
//     address: {
//       type: String,
//       required: true
//     },
//     isDefault: {
//       type: Boolean,
//       default: false
//     }
//   }],
  profileImage: {
    type: String,
    default: ''
  },
  // authType: {
  //   type: String,
  //   enum: ['local', 'admin'],
  //   default: 'local'
  // },
  role: {
    type: String,
    enum: ['user', 'admin'],
    default: 'user'
  },
  twoFactorEnabled: {
    type: Boolean,
    default: false
  },
//   googleId: String,
  resetPasswordToken: String,
  resetPasswordExpires: Date,
  createdAt: {
    type: Date,
    default: Date.now
  },
  updatedAt: {
    type: Date,
    default: Date.now
  }
}, {
  timestamps: true
});

// Update timestamp on save
userSchema.pre('save', function(next) {
  this.updatedAt = Date.now();
  next();
});

// Hash password before saving
userSchema.pre('save', async function(next) {
  try {
    // Only hash the password if it has been modified (or is new)
    if (!this.isModified('password')) {
      return next();
    }

    // Ensure password exists 
    if (this.password) {
      //console.log('Hashing password for user:', this.email);
      const salt = await bcrypt.genSalt(8);
      const hashedPassword = await bcrypt.hash(this.password, salt);
      this.password = hashedPassword;
      //console.log('Password hashed successfully');
    }
    next();
  } catch (error) {
    console.error('Password hashing error:', error);
    next(error);
  }
});

// Method to compare password
userSchema.methods.comparePassword = async function(candidatePassword) {
  try {
    // Only compare if user has a password and is using local auth
    // if (!this.password || (this.authType && this.authType !== 'local')) {
    //   console.log('Cannot compare password: no password set or non-local auth');
    //   return false;
    // }

    const isMatch = await bcrypt.compare(candidatePassword, this.password);
    //console.log('Password comparison result:', isMatch);
    return isMatch;
  } catch (error) {
    console.error('Password comparison error:', error);
    return false;
  }
};

module.exports = mongoose.model('User', userSchema);