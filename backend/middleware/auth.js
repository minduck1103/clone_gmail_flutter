const jwt = require('jsonwebtoken');
const config = require('../config/main');
const User = require('../models/User');

module.exports = async function(req, res, next) {
  // Get token from header
  const authHeader = req.header('Authorization');
  
  if (!authHeader) {
    return res.status(401).json({ message: 'No token authentication' });
  }

  // Check if it's a Bearer token
  if (!authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ message: 'Invalid token ' });
  }

  // Get the token part after "Bearer "
  const token = authHeader.split(' ')[1];
  
  try {
    console.log('Token received:', token);
    const decoded = jwt.verify(token, config.jwtSecret);
    const user = await User.findById(decoded.userId);
    if (!user) return res.status(401).json({ message: 'Unauthorized' });
    req.user = user;
    next();
  } catch (err) {
    console.log('JWT verify error:', err.message);
    res.status(401).json({ message: 'Invalid or expired token' });
  }
}; 