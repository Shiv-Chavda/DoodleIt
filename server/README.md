# Server Setup Guide

## Prerequisites
- Node.js (v14 or higher)
- npm or yarn
- MongoDB Atlas account (free tier available)

## Quick Setup

### 1. Install Dependencies
```bash
cd server
npm install
```

### 2. Configure MongoDB

#### Option A: MongoDB Atlas (Recommended for Production)
1. Go to [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
2. Create a free account
3. Create a new cluster
4. Click "Connect" and choose "Connect your application"
5. Copy the connection string
6. Update `index.js` line 15:
```javascript
const DB = "mongodb+srv://username:password@cluster.mongodb.net/doodleit?retryWrites=true&w=majority";
```

#### Option B: Local MongoDB (For Development)
1. Install MongoDB locally
2. Keep the default connection string in `index.js`:
```javascript
const DB = "mongodb://localhost:27017";
```

### 3. Run the Server

Development mode (with auto-reload):
```bash
npm run dev
```

Production mode:
```bash
npm start
```

The server will run on port 3000 by default.

## Deployment Options

### Railway
1. Create account on [Railway](https://railway.app/)
2. Click "New Project" → "Deploy from GitHub repo"
3. Select your repository
4. Add environment variable: `PORT` (Railway will set this automatically)
5. Add MongoDB connection string
6. Deploy!

### Render
1. Create account on [Render](https://render.com/)
2. Click "New +" → "Web Service"
3. Connect your repository
4. Set:
   - Build Command: `npm install`
   - Start Command: `npm start`
   - Environment: Node
5. Add environment variables
6. Deploy!

### Heroku
```bash
heroku create doodleit-server
git push heroku main
heroku config:set MONGODB_URI=your_connection_string
```

## Environment Variables (Optional)
Create a `.env` file in the server directory:
```
PORT=3000
MONGODB_URI=your_mongodb_connection_string
```

Then update `index.js`:
```javascript
require('dotenv').config();
const DB = process.env.MONGODB_URI || "mongodb://localhost:27017";
```

## Testing
Test the server is running:
```bash
curl http://localhost:3000
```

## Connecting the Flutter App
Once your server is deployed, update the Socket.IO connection in your Flutter app with your server URL:
- Local: `http://YOUR_LOCAL_IP:3000`
- Production: `https://your-server-url.com`
