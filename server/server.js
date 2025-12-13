const express = require("express");
const app = express();
const http = require("http");
const server = http.createServer(app);
const { Server } = require("socket.io");

// Configuration CORS pour GitHub Pages et développement local
const io = new Server(server, {
  cors: {
    origin: [
      "http://localhost:3000",
      "http://localhost:8080",
      "https://localhost:3000",
      "https://localhost:8080",
      // Ajouter votre domaine GitHub Pages ici après déploiement
      "https://VOTRE-USERNAME.github.io",
      "https://VOTRE-USERNAME.github.io/videochatsapp"
    ],
    methods: ["GET", "POST"],
    credentials: true
  }
});

app.use(express.json());

// Route de santé pour vérifier que le serveur fonctionne
app.get('/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  });
});

// Route d'information
app.get('/info', (req, res) => {
  res.json({
    name: 'VideoChatsApp Server',
    version: '1.0.0',
    environment: process.env.NODE_ENV || 'development',
    cors_origins: io.engine.opts.cors.origin
  });
});

// Route pour servir les fichiers statiques si nécessaire
app.use(express.static("public"));

// Routes pour servir les pages HTML (si utilisées directement)
app.get('/', (req, res) => {
  res.sendFile(__dirname + '/public/index.html');
});

app.get('/room.html', (req, res) => {
  res.sendFile(__dirname + '/public/room.html');
});

// Gestion des connexions Socket.io
io.on("connection", (socket) => {
  console.log('Un utilisateur s\'est connecté :', socket.id);

  // Garder une trace de la salle et du nom d'utilisateur pour ce socket
  let currentRoomId;
  let currentUsername;

  socket.on("join-room", (roomId, username) => {
    const room = io.sockets.adapter.rooms.get(roomId);
    const numClients = room ? room.size : 0;

    if (numClients >= 2) {
      socket.emit('room-full', roomId);
      console.log(`Salle ${roomId} pleine. ${socket.id} n'a pas pu rejoindre.`);
      return;
    }

    socket.join(roomId);
    currentRoomId = roomId;
    currentUsername = username;

    console.log(`L'utilisateur ${socket.id} (${username}) a rejoint la salle ${roomId}. Clients dans la salle: ${numClients + 1}`);

    if (numClients === 1) {
      // Si un autre utilisateur est déjà dans la salle, notifier l'utilisateur existant
      // que le nouveau s'est connecté pour initier la connexion WebRTC
      socket.to(roomId).emit('user-connected', socket.id, username);
    }
  });

  // Relayer les signaux WebRTC (offre, réponse, candidats ICE)
  socket.on("signal", (data) => {
    io.to(data.to).emit("signal", {
      from: socket.id, // On utilise socket.id comme source fiable
      signal: data.signal,
    });
  });

  // Gérer les messages du chat
  socket.on("chat-message", (msg) => {
    if (currentRoomId && currentUsername) {
      io.to(currentRoomId).emit("chat-message", {
        username: currentUsername,
        message: msg,
      });
    }
  });

  // Gérer la déconnexion de l'utilisateur
  socket.on("disconnect", () => {
    console.log('Un utilisateur s\'est déconnecté :', socket.id);
    if (currentRoomId) {
      // Notifier les autres utilisateurs que quelqu'un s'est déconnecté
      socket.to(currentRoomId).emit("user-disconnected", socket.id);
    }
  });

  // Gestion d'erreur
  socket.on("error", (error) => {
    console.error('Erreur Socket.io:', error);
  });
});

// Middleware de gestion d'erreur global
app.use((err, req, res, next) => {
  console.error('Erreur serveur:', err.stack);
  res.status(500).json({
    error: 'Erreur interne du serveur',
    message: process.env.NODE_ENV === 'development' ? err.message : 'Something went wrong!'
  });
});

// Gestion 404
app.use((req, res) => {
  res.status(404).json({
    error: 'Route non trouvée',
    path: req.path,
    method: req.method
  });
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
  console.log(`🚀 Serveur VideoChatsApp démarré sur le port ${PORT}`);
  console.log(`📡 WebSocket prêt pour les connexions`);
  console.log(`🌐 CORS configuré pour GitHub Pages et développement local`);
  
  if (process.env.NODE_ENV === 'production') {
    console.log('✅ Environnement de production');
  } else {
    console.log('🛠️ Environnement de développement');
  }
});

// Gestion propre de l'arrêt du serveur
process.on('SIGTERM', () => {
  console.log('🛑 Réception SIGTERM, arrêt propre du serveur...');
  server.close(() => {
    console.log('✅ Serveur arrêté proprement');
    process.exit(0);
  });
});

process.on('SIGINT', () => {
  console.log('🛑 Réception SIGINT, arrêt propre du serveur...');
  server.close(() => {
    console.log('✅ Serveur arrêté proprement');
    process.exit(0);
  });
});