require('dotenv').config();
const express = require("express");
var http = require("http");
const app = express();
const port = process.env.PORT || 3000;
var server = http.createServer(app);
const mongoose = require("mongoose");
const Room = require('./models/Room');
const getWord = require('./api/getWord');

var io = require("socket.io")(server, {
    cors: {
        origin: "*",
        methods: ["GET", "POST"]
    }
});

//middleware
app.use(express.json());

// Health check endpoint
app.get('/', (req, res) => {
    res.json({ status: 'DoodleIt Server is running!', timestamp: new Date() });
});

// Database check endpoint
app.get('/db-status', async (req, res) => {
    try {
        const roomCount = await Room.countDocuments();
        const rooms = await Room.find({}).select('name players.nickname currentRound');
        res.json({ 
            connected: mongoose.connection.readyState === 1,
            database: mongoose.connection.name,
            totalRooms: roomCount,
            rooms: rooms
        });
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Use environment variable for production, fallback to localhost for development
const DB = process.env.MONGODB_URI || "mongodb://localhost:27017/doodleit";

console.log('Attempting to connect to MongoDB at:', DB);

mongoose.connect(DB).then(()=>{
    console.log("✅ Connected successfully to MongoDB");
    console.log('📊 Database name:', mongoose.connection.name);
}).catch((e)=>{
    console.error("❌ MongoDB connection error:", e.message);
    console.log('\n🔧 Troubleshooting:');
    console.log('1. Make sure MongoDB is running');
    console.log('2. Check connection string:', DB);
})

mongoose.connection.on('error', (err) => {
    console.error('MongoDB runtime error:', err);
});

mongoose.connection.on('disconnected', () => {
    console.log('MongoDB disconnected');
});

io.on('connection', (socket) => {
    console.log('connected successfully to socket');

    //on creating the room
    socket.on('create-game', async({nickname,name,occupancy,maxRounds}) => {
        try{
            console.log(`📝 Creating room: ${name} by ${nickname}`);
            const existingRoom = await Room.findOne({name});

            // room already exists
            if(existingRoom){
                console.log('❌ Room with that name already exists:', name);
                socket.emit('notCorrectGame' , 'room with that name already exists!');
                return;
            }

            //making new room
            let room = new Room();
            const word = getWord();
            room.word = word;
            room.name = name;
            room.occupancy = occupancy;
            room.maxRounds = maxRounds;

            let player = {
                socketID : socket.id,
                nickname,
                isPartyLeader: true,
            }
            room.players.push(player);
            console.log('💾 Saving room to database:', {name: room.name, players: room.players.length});

            room = await room.save();
            console.log('✅ Room saved successfully with ID:', room._id);
            socket.join(name);
            io.to(name).emit('updateRoom', room);
        }catch (e){
            console.error('❌ Error creating room:', e.message);
            console.error(e);
            socket.emit('notCorrectGame', 'Error creating room: ' + e.message);
        }
    });

    //on joining the room
    socket.on('join-game', async({nickname, name}) => {
        try {
            console.log(`🚪 ${nickname} attempting to join room: ${name}`);
            let room = await Room.findOne({name});

            //room doesn't exists
            if(!room){
                console.log("❌ Room not found:", name);
                socket.emit('notCorrectGame' , 'please enter the valid room name');
                return;
            }

            //joining room
            if(room.isJoin){
                let player = {
                    socketID: socket.id,
                    nickname,
                };
                room.players.push(player);
                console.log('💾 Updating room with new player:', {room: name, totalPlayers: room.players.length});

                socket.join(name);

                //room occupancy
                if(room.players.length >= room.occupancy){
                    room.isJoin = false;
                    console.log('🔒 Room is now full');
                }
                room.turn = room.players[room.turnIndex];
                room = await room.save();
                console.log('✅ Player joined successfully');
                io.to(name).emit('updateRoom', room);
            }else{
                console.log("❌ Room is already full:", name);
                socket.emit('notCorrectGame' , 'room is already full');
            }
        } catch (e){
            console.error('❌ Error joining room:', e.message);
            console.error(e);
        }
    });

//white board sockets
    //on painting the screen
    socket.on('paint', ({details, color, strokeWidth, roomName}) => {
        io.to(roomName).emit('points', {details: details, color: color, strokeWidth: strokeWidth});
    });

    //on changing the color
    socket.on('color-change', ({color, roomName})=>{
        io.to(roomName).emit('color-change', color);
    });

    //on changing the stroke width
    socket.on('stroke-width', ({value, roomName})=>{
        io.to(roomName).emit('stroke-width', value);
    });

    //clear screen socket
    socket.on('clear-screen', (roomName)=>{
        io.to(roomName).emit('clear-screen', '');
    });

    //on message sent
    socket.on('msg', async (data) => {
        console.log(data);
        try{
            if(data.msg === data.word){
                // fetch the single room document
                let room = await Room.findOne({name: data.roomName});
                let userPlayer = room.players.filter(
                    (player) => player.nickname == data.username
                );
                if (data.timeTaken !== 0){
                    userPlayer[0].points += Math.round((200/data.timeTaken) * 10);
                }
                await room.save();
                const newGuessedCount = data.guessedUserCtr + 1;
                io.to(data.roomName).emit('msg',{
                    username: data.username,
                    msg: 'Guessed it!',
                    guessedUserCtr : newGuessedCount,
                });
                socket.emit('close-input', '');
                
                // Auto change turn when all players except drawer have guessed
                if (newGuessedCount >= room.players.length - 1) {
                    // Small delay to ensure message is displayed before turn change
                    setTimeout(async () => {
                        let updatedRoom = await Room.findOne({name: data.roomName});
                        let idx = updatedRoom.turnIndex;
                        if (idx+1 === updatedRoom.players.length){
                            updatedRoom.currentRound += 1;
                        }
                        if (updatedRoom.currentRound <= updatedRoom.maxRounds){
                            const word = getWord();
                            updatedRoom.word = word;
                            updatedRoom.turnIndex = (idx+1) % updatedRoom.players.length;
                            updatedRoom.turn = updatedRoom.players[updatedRoom.turnIndex];
                            updatedRoom = await updatedRoom.save();
                            io.to(data.roomName).emit('change-turn', updatedRoom);
                        }else{
                            io.to(data.roomName).emit('show-leaderboard', updatedRoom.players);
                        }
                    }, 500);
                }
            }else{
                io.to(data.roomName).emit('msg',{
                    username: data.username,
                    msg: data.msg,
                    guessedUserCtr : data.guessedUserCtr,
                });
            }
        }catch (e){
            console.log(e.toString());
        }
    });

    //on changing the turn
    socket.on('change-turn', async (name)=>{
       try{
           let room = await Room.findOne({name});
           let idx = room.turnIndex;
           if (idx+1 === room.players.length){
               room.currentRound += 1;
           }
           if (room.currentRound <= room.maxRounds){
               const word = getWord();
               room.word = word;
               room.turnIndex = (idx+1) % room.players.length;
               room.turn = room.players[room.turnIndex];
               room = await room.save();
               io.to(name).emit('change-turn', room);
           }else{
               io.to(name).emit('show-leaderboard', room.players);
           }
       } catch (e){
           console.log(e);
       }
    });

    //updating the score
    socket.on('update-score', async (name)=>{
        try{
            const room = await Room.findOne({name});
            io.to(name).emit('update-score', room);
        }catch (e){
            console.log(e);
        }
    });

    //disconnecting the socket
    socket.on('disconnect', async ()=>{
        try{
            let room = await Room.findOne({'players.socketID': socket.id});
            for(let i=0; i<room.players.length; i++) {
                if(room.players[i].socketID === socket.id) {
                    room.players.splice(i, 1);
                    break;
                }
            }
            room = await room.save();
            if(room.players.length === 1) {
                socket.broadcast.to(room.name).emit('show-leaderboard', room.players);
            } else {
                socket.broadcast.to(room.name).emit('user-disconnected', room);
            }
//            DB.collection("Room").remove(room, function(err, obj) {
//                if (err) throw err;
//                console.log(obj.result.n + " document(s) deleted");
//                DB.close();
//            });
        }catch (err){
            console.log(err);
        }
    })
})

server.listen(port, "0.0.0.0", ()=>{
    console.log('Server started and running in port ' + port);
})
