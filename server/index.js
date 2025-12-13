const express = require("express");
const http = require("http");
const { Server } = require("socket.io");

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
  cors: {
// Configuration CORS pour akili2/videochatsapp-template
    origin: [
      "http://localhost:3000",
      "http://localhost:8080",
      "https://localhost:3000",
      "https://localhost:8080",
      "https://akili2.github.io",
      "https://akili2.github.io/videochatsapp-template"
    ],
    methods: ["GET", "POST"],
    credentials: true
  }
});

// Middleware
app.use(express.json());

// Routes de santé et info
app.get('/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    service: 'VideoChatsApp Backend'
  });
});

app.get('/info', (req, res) => {
  res.json({
    name: 'VideoChatsApp Backend',
    version: '1.0.0',
    environment: process.env.NODE_ENV || 'development',
    cors_origins: io.engine.opts.cors.origin,
    websocket: 'Socket.io ready'
  });
});

// Servir les fichiers statiques du frontend
app.use(express.static('public'));

// Routes pour les pages HTML
app.get('/', (req, res) => {
  res.sendFile(__dirname + '/public/index.html');
});

app.get('/room.html', (req, res) => {
  res.sendFile(__dirname + '/public/room.html');
});

// Gestion WebRTC et Socket.io
io.on("connection", (socket) => {
  console.log('🟢 Utilisateur connecté:', socket.id);

  let currentRoomId;
  let currentUsername;

  socket.on("join-room", (roomId, username) => {
    const room = io.sockets.adapter.rooms.get(roomId);
    const numClients = room ? room.size : 0;

    if (numClients >= 2) {
      socket.emit('room-full', roomId);
      console.log(`🔴 Salle ${roomId} pleine. ${socket.id} bloqué.`);
      return;
    }

    socket.join(roomId);
    currentRoomId = roomId;
    currentUsername = username;

    console.log(`🟡 ${username} (${socket.id}) a rejoint la salle ${roomId}. Clients: ${numClients + 1}`);

    if (numClients === 1) {
      socket.to(roomId).emit('user-connected', socket.id, username);
    }
  });

  // Signaux WebRTC
  socket.on("signal", (data) => {
    io.to(data.to).emit("signal", {
      from: socket.id,
      signal: data.signal,
    });
  });

  // Chat
  socket.on("chat-message", (msg) => {
    if (currentRoomId && currentUsername) {
      io.to(currentRoomId).emit("chat-message", {
        username: currentUsername,
        message: msg,
      });
    }
  });

  // Déconnexion
  socket.on("disconnect", () => {
    console.log('🔴 Utilisateur déconnecté:', socket.id);
    if (currentRoomId) {
      socket.to(currentRoomId).emit("user-disconnected", socket.id);
    }
  });

  socket.on("error", (error) => {
    console.error('❌ Erreur Socket.io:', error);
  });
});

// Gestion d'erreurs
app.use((err, req, res, next) => {
  console.error('❌ Erreur serveur:', err.stack);
  res.status(500).json({
    error: 'Erreur interne du serveur',
    message: process.env.NODE_ENV === 'development' ? err.message : 'Something went wrong!'
  });
});

app.use((req, res) => {
  res.status(404).json({
    error: 'Route non trouvée',
    path: req.path,
    method: req.method
  });
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
  console.log(`🚀 VideoChatsApp Backend démarré sur le port ${PORT}`);
  console.log(`📡 WebSocket: Socket.io prêt`);
  console.log(`🌐 CORS configuré pour GitHub Pages`);
  console.log(`🔗 Health: http://localhost:${PORT}/health`);
  console.log(`ℹ️  Info: http://localhost:${PORT}/info`);
  
  if (process.env.NODE_ENV === 'production') {
    console.log('✅ Environnement de production');
  } else {
    console.log('🛠️ Environnement de développement');
  }
});

// Arrêt propre
process.on('SIGTERM', () => {
  console.log('🛑 Arrêt propre du serveur...');
  server.close(() => {
    console.log('✅ Serveur arrêté');
    process.exit(0);
  });
});

process.on('SIGINT', () => {
  console.log('🛑 Arrêt propre du serveur...');
  server.close(() => {
    console.log('✅ Serveur arrêté');
    process.exit(0);
  });
});