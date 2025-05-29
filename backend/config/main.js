require('dotenv').config();

module.exports = {
  port: process.env.PORT || 5000,
  mongoURL: process.env.MONGODB_URI || 'mongodb://localhost:27017/Email',
  jwtSecret: process.env.JWT_SECRET || 'your-secret-key',
  clientURL: process.env.CLIENT_URL || 'http://localhost:3000'
}; 