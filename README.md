
# 🎨 DoodleIt - Flutter Mobile App

This repository contains a Flutter-based mobile application that serves as a mobile version of the popular online drawing and guessing game [skribbl.io](https://skribbl.io/). The app leverages `socket.io` for real-time communication and `MongoDB` for persistent data storage.

## 📱 Features

- **Real-Time Drawing and Guessing:** Just like the web version, users can draw and guess in real-time.
- **Multiplayer Support:** Play with friends or other users from around the world.
- **Custom Game Rooms:** Create private rooms to play with specific people.
- **Cross-Platform:** Available on both Android and iOS devices.
- **User Authentication:** Secure login and registration using MongoDB for data persistence.
- **Leaderboard:** Track the top players in different game rooms.

## 🛠️ Technologies Used

- **Flutter:** The app is built using Flutter for a beautiful and responsive user interface.
- **Socket.IO:** Handles real-time, bidirectional communication between clients and server.
- **Node.js:** Backend server to manage game logic and user interactions.
- **Express.js:** Web framework for Node.js to build RESTful APIs.
- **MongoDB:** Database to store user information, game data, and leaderboards.
- **Firebase:** Used for authentication and cloud messaging.

## 🚀 Getting Started

### Prerequisites

- Flutter SDK
- Node.js and npm
- MongoDB

### Installation

1. **Clone the repository:**
   ```sh
   git clone https://github.com/Shiv-Chavda/DoodleIt.git
   cd DoodleIt
   ```

2. **Install dependencies:**
   ```sh
   flutter pub get
   ```
3. **Configure Supabase:**
   - Create a MongoDB project.
   - Obtain your MongoDB project URL from the project settings.
   - A file named `server/index.js` in the root of your project and add the following code, replacing the placeholders with your actual values:
     ```sh
     const DB = YOUR_MONGODB_URL;
     ```

4. **Set up the backend server:**
   - Navigate to the `server` directory:
     ```sh
     cd server
     ```
   - Install server dependencies:
     ```sh
     npm install
     ```
   - Start the server:
     ```sh
     node server.js
     ```

5. **Run the app:**
   ```sh
   flutter run
   ```

### Configuration

Ensure you have the correct configuration for `MongoDB` and `Socket.IO` in your `server` and `Flutter` application files. Update the `config` files with your MongoDB URI and any other necessary environment variables.
