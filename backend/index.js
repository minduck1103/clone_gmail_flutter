require('dotenv').config();
const express = require('express');
const cors = require('cors');
const session = require('express-session');
const path = require('path');
const connectDB = require('./config/db');
const config = require('./config/main');
//const addressRoutes = require('./routes/address');
const fs = require('fs');
//const User = require('./models/User');
const http = require('http');
const { Server } = require('socket.io');

// Initialize Express app
const app = express();
const server = http.createServer(app);
const io = new Server(server, {
  cors: { origin: '*' }
});

// Trust proxy for rate limiting
app.set('trust proxy', 1);

// Connect to MongoDB
connectDB(config.mongoURL);

// Middleware
app.use((req, res, next) => {
  req.io = io;
  next();
});
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors({
  origin: config.clientURL,
  credentials: true
}));

// Session configuration
app.use(session({
  secret: process.env.SESSION_SECRET || 'your-secret-key',
  resave: false,
  saveUninitialized: false,
  cookie: {
    secure: process.env.NODE_ENV === 'production',
    maxAge: 24 * 60 * 60 * 1000 // 24 hours
  }
}));

// Ensure uploads directory exists
const uploadsDir = path.join(__dirname, 'uploads');
const profileDir = path.join(uploadsDir, 'profile');

if (!fs.existsSync(uploadsDir)) {
  fs.mkdirSync(uploadsDir);
}

if (!fs.existsSync(profileDir)) {
  fs.mkdirSync(profileDir);
}

//Routes
app.use('/api/auth', require('./routes/auth'));
app.use('/api/user', require('./routes/user'));

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ message: 'Something broke!' });
});

// Start server
const PORT = config.port;
server.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

