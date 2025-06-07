# Gmail Clone - Flutter & Node.js

Một ứng dụng clone Gmail được xây dựng bằng **Flutter** (Frontend) và **Node.js** (Backend) với cơ sở dữ liệu **MongoDB**.

## 🚀 Tính năng chính

### 📧 Quản lý Email
- ✅ Gửi, nhận, trả lời email
- ✅ Chuyển tiếp email (Forward)
- ✅ Trả lời tất cả (Reply All)  
- ✅ Đánh dấu đã đọc/chưa đọc
- ✅ Gắn sao/bỏ sao email
- ✅ Chuyển vào thùng rác
- ✅ Xóa vĩnh viễn
- ✅ Quản lý nhãn (Labels)
- ✅ Tìm kiếm email
- ✅ Đính kèm file

### 🤖 Tính năng thông minh
- ✅ **Auto Answer** - Tự động trả lời email khi vắng mặt
- ✅ Phân loại email (Primary, Social, Promotions, Updates)
- ✅ Hiển thị email chưa đọc với font đậm

### 👤 Quản lý tài khoản
- ✅ Đăng ký/Đăng nhập
- ✅ **Upload Avatar** - Thay đổi ảnh đại diện
- ✅ Quản lý thông tin cá nhân
- ✅ Cài đặt ứng dụng
- ✅ Bảo mật tài khoản

### 📱 Giao diện
- ✅ Material Design 3
- ✅ Responsive UI
- ✅ Dark/Light theme
- ✅ Drawer navigation
- ✅ Bottom sheets và dialogs
- ✅ Loading states và error handling

## 🛠️ Công nghệ sử dụng

### Frontend (Flutter)
- **Flutter 3.x** - Cross-platform mobile framework
- **Provider** - State management
- **HTTP** - API calls
- **Image Picker** - Upload ảnh
- **File Picker** - Đính kèm file
- **Material Design 3** - UI Components

### Backend (Node.js)
- **Node.js** - JavaScript runtime
- **Express.js** - Web framework
- **MongoDB** - NoSQL database
- **Mongoose** - MongoDB object modeling
- **JWT** - Authentication
- **Multer** - File upload
- **Bcrypt** - Password hashing

## 📋 Yêu cầu hệ thống

### Phần mềm cần thiết
- **Flutter SDK** >= 3.2.3
- **Node.js** >= 16.0.0
- **MongoDB** >= 5.0
- **Git**
- **VS Code** hoặc **Android Studio** (khuyên dùng)

### Thiết bị
- **Android**: API level 21 (Android 5.0) trở lên
- **iOS**: iOS 11 trở lên  
- **RAM**: Tối thiểu 4GB (khuyên dùng 8GB)

## 🗄️ Cài đặt MongoDB

### Cách 1: MongoDB Atlas (Cloud - Khuyên dùng)

1. Truy cập [MongoDB Atlas](https://www.mongodb.com/atlas)
2. Tạo tài khoản miễn phí
3. Tạo cluster mới:
   - Chọn **FREE** tier
   - Chọn region gần nhất (Singapore cho VN)
   - Cluster Name: `gmail-clone`
4. Tạo Database User:
   - Username: `admin`
   - Password: `password123` (hoặc password mạnh khác)
5. Whitelist IP Address:
   - Chọn **Allow Access from Anywhere** (0.0.0.0/0)
6. Lấy Connection String:
   ```
   mongodb+srv://admin:<password>@gmail-clone.xxxxx.mongodb.net/gmail_clone?retryWrites=true&w=majority
   ```

### Cách 2: MongoDB Local

#### Windows:
1. Tải MongoDB Community Server từ [mongodb.com](https://www.mongodb.com/try/download/community)
2. Cài đặt với các tùy chọn mặc định
3. Khởi động MongoDB service:
   ```bash
   net start MongoDB
   ```

#### macOS:
```bash
# Cài đặt qua Homebrew
brew tap mongodb/brew
brew install mongodb-community
brew services start mongodb/brew/mongodb-community
```

#### Linux (Ubuntu):
```bash
# Import public key
wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -

# Create list file
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list

# Install MongoDB
sudo apt-get update
sudo apt-get install -y mongodb-org

# Start MongoDB
sudo systemctl start mongod
sudo systemctl enable mongod
```

## ⚙️ Cài đặt và chạy dự án

### 1. Clone repository
```bash
git clone <https://github.com/minduck1103/clone_gmail_flutter.git>
cd clone_gmail_flutter
```

### 2. Cài đặt Backend

```bash
# Di chuyển vào thư mục backend
cd backend

# Cài đặt dependencies
npm install

# Tạo file .env
cp .env.example .env
```

**Cấu hình file `.env`:**
```env
# Database
MONGODB_URI=mongodb://localhost:27017/gmail_clone
# Hoặc sử dụng MongoDB Atlas:
# MONGODB_URI=mongodb+srv://admin:password123@gmail-clone.xxxxx.mongodb.net/gmail_clone?retryWrites=true&w=majority

# JWT Secret
JWT_SECRET=your-super-secret-jwt-key-here-make-it-long-and-complex

# Server
PORT=3000
NODE_ENV=development

# Upload
UPLOAD_PATH=uploads/
MAX_FILE_SIZE=10485760

# Email (Optional - cho auto answer)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-app-password
```

**Chạy Backend:**
```bash
# Development mode (với auto-restart)
npm run dev

# Production mode
npm start
```

Backend sẽ chạy tại: `http://localhost:3000`

### 3. Cài đặt Frontend

```bash
# Di chuyển vào thư mục frontend (terminal mới)
cd frontend

# Cài đặt dependencies
flutter pub get

# Tạo file .env
cp .env.example .env
```

**Cấu hình file `frontend/.env`:**
```env
# API Base URL
API_BASE_URL=http://localhost:3000/api
# Hoặc IP của máy bạn nếu test trên thiết bị thật:
# API_BASE_URL=http://192.168.1.100:3000/api
```

**Chạy Frontend:**
```bash
# Kiểm tra devices available
flutter devices

# Chạy trên emulator/simulator
flutter run

# Chạy trên device cụ thể
flutter run -d <device-id>

# Build APK (Android)
flutter build apk --release

# Build iOS (macOS only)
flutter build ios --release
```

## 📁 Cấu trúc dự án

```
clone_gmail_flutter/
├── backend/                 # Node.js Backend
│   ├── controllers/         # API Controllers
│   ├── models/             # Database Models
│   ├── routes/             # API Routes
│   ├── middleware/         # Custom Middleware
│   ├── config/             # Configuration files
│   ├── uploads/            # File uploads
│   ├── .env               # Environment variables
│   └── server.js          # Entry point
│
├── frontend/               # Flutter Frontend
│   ├── lib/
│   │   ├── models/         # Data models
│   │   ├── screens/        # UI Screens
│   │   ├── widgets/        # Reusable widgets
│   │   ├── services/       # API & Business logic
│   │   └── main.dart       # Entry point
│   ├── assets/             # Images, fonts, etc.
│   ├── .env               # Environment variables
│   └── pubspec.yaml       # Dependencies
│
└── README.md              # Documentation
```

## 🔌 API Endpoints

### Authentication
- `POST /api/auth/register` - Đăng ký
- `POST /api/auth/login` - Đăng nhập
- `POST /api/auth/logout` - Đăng xuất
- `POST /api/auth/forgot-password` - Quên mật khẩu
- `POST /api/auth/reset-password/:token` - Reset mật khẩu

### User Management
- `GET /api/user/account` - Thông tin tài khoản
- `PUT /api/user/account` - Cập nhật thông tin
- `POST /api/user/avatar` - Upload avatar
- `GET /api/user/preferences` - Lấy cài đặt
- `PUT /api/user/preferences` - Cập nhật cài đặt

### Email Operations
- `GET /api/mail/user/inbox` - Hộp thư đến
- `GET /api/mail/user/sent` - Thư đã gửi
- `GET /api/mail/user/drafts` - Bản nháp
- `GET /api/mail/user/trash` - Thùng rác
- `GET /api/mail/user/starred` - Thư có sao
- `POST /api/mail` - Gửi email mới
- `GET /api/mail/:id` - Chi tiết email
- `PATCH /api/mail/:id/read` - Đánh dấu đã đọc
- `PATCH /api/mail/:id/star` - Gắn/bỏ sao
- `PATCH /api/mail/:id/trash` - Chuyển vào thùng rác
- `DELETE /api/mail/:id` - Xóa vĩnh viễn
- `POST /api/mail/:id/reply` - Trả lời email
- `POST /api/mail/:id/forward` - Chuyển tiếp

### Labels
- `GET /api/label` - Danh sách nhãn
- `POST /api/label` - Tạo nhãn mới
- `PUT /api/label` - Cập nhật nhãn
- `DELETE /api/label` - Xóa nhãn

## 🧪 Testing

### Test Backend APIs
```bash
# Sử dụng curl hoặc Postman
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"phone":"0123456789","fullname":"Test User","password":"password123"}'
```

### Test Frontend
```bash
cd frontend
flutter test
```

## 🚀 Deploy

### Backend (Heroku)
```bash
# Cài đặt Heroku CLI
npm install -g heroku

# Login và tạo app
heroku login
heroku create gmail-clone-backend

# Set environment variables
heroku config:set MONGODB_URI=your-mongodb-atlas-uri
heroku config:set JWT_SECRET=your-jwt-secret

# Deploy
git subtree push --prefix backend heroku main
```

### Frontend (Firebase Hosting)
```bash
# Build web app
flutter build web

# Install Firebase CLI
npm install -g firebase-tools

# Deploy
firebase login
firebase init hosting
firebase deploy
```

## 🐛 Troubleshooting

### Backend Issues

**MongoDB Connection Error:**
```bash
# Kiểm tra MongoDB đang chạy
mongosh
# Hoặc
mongo

# Nếu lỗi, restart MongoDB
sudo systemctl restart mongod  # Linux
brew services restart mongodb-community  # macOS
net stop MongoDB && net start MongoDB  # Windows
```

**Port đã được sử dụng:**
```bash
# Tìm process đang sử dụng port 3000
lsof -i :3000  # macOS/Linux
netstat -ano | findstr :3000  # Windows

# Kill process
kill -9 <PID>  # macOS/Linux
taskkill /PID <PID> /F  # Windows
```

### Frontend Issues

**Flutter Doctor Issues:**
```bash
flutter doctor
flutter doctor --android-licenses  # Accept Android licenses
```

**API Connection Error:**
- Kiểm tra backend đang chạy tại `http://localhost:3000`
- Kiểm tra file `.env` có đúng API_BASE_URL
- Nếu test trên device thật, sử dụng IP của máy thay vì localhost

**Build Errors:**
```bash
flutter clean
flutter pub get
flutter pub upgrade
```

## 🙏 Cảm ơn

- [Flutter Team](https://flutter.dev) - Amazing cross-platform framework
- [MongoDB](https://www.mongodb.com) - Flexible NoSQL database
- [Material Design](https://material.io) - Beautiful design system
- [Node.js Community](https://nodejs.org) - Powerful JavaScript runtime

---

⭐ **Nếu dự án này hữu ích, hãy cho một star nhé!** ⭐ 