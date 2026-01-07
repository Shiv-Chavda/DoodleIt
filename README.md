# 🎨 DoodleIt - Mobile Drawing & Guessing Game

A real-time multiplayer drawing and guessing game for Android and iOS, inspired by the popular game Skribbl.io. Built with Flutter for mobile platforms and powered by Socket.IO for real-time communication and MongoDB for data persistence.

## 📱 Features

- **Real-Time Multiplayer:** Draw and guess with friends in real-time
- **Custom Game Rooms:** Create private rooms with room codes
- **Live Scoring:** Real-time leaderboard and scoring system  
- **Interactive Drawing:** Smooth drawing canvas with color picker
- **Chat System:** Guess words through the integrated chat
- **Mobile-First:** Optimized for Android and iOS devices
- **Beautiful UI:** Clean, modern interface with smooth animations

## 🛠️ Technologies Used

### Frontend (Mobile)
- **Flutter:** Cross-platform mobile app framework
- **Socket.IO Client:** Real-time bidirectional communication
- **Flutter ColorPicker:** Color selection for drawing
- **Google Fonts:** Custom typography
- **Flutter Animate:** Smooth animations

### Backend
- **Node.js:** JavaScript runtime for the server
- **Express.js:** Web framework for RESTful APIs
- **Socket.IO:** Real-time event-based communication
- **MongoDB:** NoSQL database for storing game data

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.3.4 or higher)
- Node.js and npm
- MongoDB Atlas account or local MongoDB instance
- Android Studio / Xcode for mobile development

### Installation

1. **Clone the repository:**
   ```sh
   git clone https://github.com/Shiv-Chavda/DoodleIt.git
   cd DoodleIt
   ```

2. **Install Flutter dependencies:**
   ```sh
   flutter pub get
   ```

3. **Set up the backend server:**
   - Navigate to the server directory:
     ```sh
     cd server
     ```
   - Install server dependencies:
     ```sh
     npm install
     ```
   - Create a `.env` file or update `index.js` with your MongoDB connection string:
     ```javascript
     const DB = "your_mongodb_connection_string";
     ```
   - Start the server:
     ```sh
     node index.js
     ```

4. **Configure server URL in the app:**
   - Update the Socket.IO server URL in your Flutter app to point to your backend server
   - For local development: `http://YOUR_LOCAL_IP:3000`
   - For production: Use your deployed server URL

5. **Run the mobile app:**
   ```sh
   flutter run
   ```

### Building for Production

**Android:**
```sh
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

**iOS:**
```sh
flutter build ios --release
```

## 📦 Project Structure

```
DoodleIt/
├── lib/
│   ├── main.dart              # App entry point
│   ├── constants/             # Color constants
│   ├── models/                # Data models
│   ├── screens/               # App screens
│   │   ├── home_screen.dart
│   │   ├── create_room_screen.dart
│   │   ├── join_room_screen.dart
│   │   ├── paint_screen.dart
│   │   ├── waiting_lobby_screen.dart
│   │   └── final_leaderboard.dart
│   ├── widgets/               # Reusable widgets
│   └── sidebar/               # Drawer components
├── server/                    # Node.js backend
│   ├── index.js              # Server entry point
│   ├── models/               # Database models
│   └── api/                  # API routes
├── android/                   # Android-specific files
├── ios/                       # iOS-specific files
└── assets/                    # Images and fonts
```

## 🎮 How to Play

1. **Create or Join Room:** Start by creating a new room or joining an existing one with a room code
2. **Wait for Players:** Wait in the lobby for other players to join
3. **Draw Your Word:** When it's your turn, you'll get a word to draw
4. **Guess Words:** When others are drawing, type your guesses in the chat
5. **Earn Points:** Correct guesses earn you points
6. **Win the Game:** Player with the highest score wins!

## 🔧 Configuration

### Server Setup
- Deploy your Node.js server to platforms like:
  - Railway
  - Render
  - Heroku
  - AWS/GCP/Azure

### MongoDB Setup
- Create a free MongoDB Atlas cluster
- Get your connection string
- Update it in `server/index.js`

### App Configuration
- Update bundle identifiers:
  - Android: `com.shivchavda.doodleit`
  - iOS: `com.shivchavda.doodleit`

## 📱 Publishing

### Google Play Store
1. Create a Google Play Developer account ($25 one-time fee)
2. Build release APK/AAB
3. Create store listing with screenshots
4. Submit for review

### Apple App Store  
1. Create Apple Developer account ($99/year)
2. Build release IPA
3. Create App Store listing
4. Submit for review

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is open source and available under the MIT License.

## 👨‍💻 Developer

**Shiv Chavda**
- GitHub: [@Shiv-Chavda](https://github.com/Shiv-Chavda)

## 🙏 Acknowledgments

- Inspired by [Skribbl.io](https://skribbl.io/)
- Built with Flutter and Socket.IO

---

**Note:** This is a mobile-only application for Android and iOS platforms.
