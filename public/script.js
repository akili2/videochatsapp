// Configuration automatique pour le déploiement
// Cette ligne sera remplacée automatiquement lors du déploiement
// Configuration automatique pour akili2/videochatsapp-template
const BACKEND_URL = window.location.hostname === 'localhost' ? '' : 'https://videochatsapp.onrender.com';
const socket = io(BACKEND_URL || undefined);
const urlParams = new URLSearchParams(window.location.search);
const roomId = urlParams.get("room");
const username = urlParams.get("username") || "Invité";

// Vérifier si roomId est présent, sinon rediriger vers la page d'accueil (sécurité)
if (!roomId) {
  alert("ID de salle manquant. Redirection vers la page d'accueil.");
  window.location.href = "/";
}

const localVideo = document.getElementById("localVideo");
const remoteVideoContainer = document.getElementById("remoteVideoContainer"); // Nouveau conteneur pour la vidéo distante
const remoteVideo = document.getElementById("remoteVideo");
const messageInput = document.getElementById("messageInput"); // Chat
const messagesDiv = document.getElementById("messages"); // Chat
const sendBtn = document.getElementById("sendBtn"); // Chat
const muteAudioBtn = document.getElementById("muteAudioBtn"); // Contrôles
const muteVideoBtn = document.getElementById("muteVideoBtn"); // Contrôles
const hangupBtn = document.getElementById("hangupBtn"); // Contrôles

document.getElementById("currentRoomIdDisplay").textContent = roomId;
document.getElementById("localUsernameDisplay").textContent = username;

let localStream;
let peerConnection;
let otherUserId; // Pour stocker l'ID de l'autre utilisateur
let isAudioMuted = false;
let isVideoMuted = false;

// Configuration STUN pour l'hébergement gratuit (plusieurs serveurs pour la redondance)
const config = {
  iceServers: [
    { urls: "stun:stun.l.google.com:19302" },
    { urls: "stun:stun1.l.google.com:19302" },
    { urls: "stun:stun2.l.google.com:19302" },
    { urls: "stun:stun3.l.google.com:19302" },
    { urls: "stun:stun4.l.google.com:19302" }
  ],
};

// Fonction pour créer et configurer la connexion pair-à-pair
function createPeerConnection(isInitiator) {
  peerConnection = new RTCPeerConnection(config);
  
  // Ajouter les pistes du flux local à la connexion
  // S'assurer que localStream existe avant d'ajouter les pistes
  if (localStream) { // Cette vérification est redondante si initializeMedia est toujours appelé avant
    localStream.getTracks().forEach(track => {
    peerConnection.addTrack(track, localStream);
  });
  }

  // Quand un flux distant est reçu, l'afficher
  peerConnection.ontrack = event => {
    console.log("Flux vidéo distant reçu");
    remoteVideo.srcObject = event.streams[0];
    remoteVideoContainer.classList.remove("hidden"); // Afficher le conteneur de la vidéo distante
  };

  // Envoyer les candidats ICE à l'autre pair
  peerConnection.onicecandidate = event => {
    if (event.candidate && otherUserId) {
      socket.emit("signal", {
        to: otherUserId, // Envoyer au pair spécifique
        signal: { candidate: event.candidate },
      });
    }
  };

  // Si nous sommes l'initiateur, nous créons l'offre
  if (isInitiator) {
    peerConnection.createOffer()
      .then(offer => peerConnection.setLocalDescription(offer))
      .then(() => {
        console.log("Offre créée et envoyée à", otherUserId);
        socket.emit("signal", {
          to: otherUserId,
          signal: { sdp: peerConnection.localDescription },
        });
      })
      .catch(e => console.error("Erreur createOffer", e));
  }
}

// 1. Démarrer en demandant l'accès à la caméra
navigator.mediaDevices.getUserMedia({ video: true, audio: true }) // Demander les deux pour commencer
  .then(stream => {
    localStream = stream;
    localVideo.srcObject = stream;
    // Une fois le flux local obtenu, on peut rejoindre la salle
    socket.emit("join-room", roomId, username);
  })
  .catch(err => { // Gérer les erreurs d'accès à la caméra/micro
    console.error("Erreur getUserMedia:", err);
    alert("Impossible d'accéder à la caméra/micro. Veuillez vérifier les autorisations.");
    // Rediriger si l'accès est refusé pour éviter une page vide
    window.location.href = "/";
  });

// --- Gestionnaires d'événements Socket.IO ---

socket.on('room-full', (roomId) => {
    alert(`La salle ${roomId} est pleine. Redirection vers l'accueil.`);
    window.location.href = "/";
});

// Reçu par le premier utilisateur quand un deuxième rejoint
// C'est le premier utilisateur qui initie la connexion WebRTC
socket.on("user-connected", (id, name) => {
  console.log(`Utilisateur ${name} (${id}) a rejoint.`);
  otherUserId = id;
  // On est le premier dans la salle (ou déjà là), on initie l'appel vers le nouvel arrivant
  if (localStream) { // S'assurer que le flux local est prêt avant de créer la connexion
    createPeerConnection(true);
  }
});

// Reçu par le deuxième utilisateur (offre) ou par les deux (réponse, ICE)
// C'est le deuxième utilisateur qui répond à l'offre
socket.on("signal", async data => {
  // Si on n'a pas encore de connexion et qu'on reçoit une offre, on en crée une
  if (data.signal.sdp && data.signal.sdp.type === 'offer' && !peerConnection) {
    otherUserId = data.from;
    if (localStream) { createPeerConnection(false); } // S'assurer que le flux local est prêt
  }

  if (data.signal.sdp) {
    // C'est une offre ou une réponse
    try {
      await peerConnection.setRemoteDescription(new RTCSessionDescription(data.signal.sdp));
      if (peerConnection.remoteDescription.type === "offer") {
        // On a reçu une offre, on doit créer une réponse
        const answer = await peerConnection.createAnswer();
        await peerConnection.setLocalDescription(answer);
        console.log("Réponse créée et envoyée à", data.from);
        socket.emit("signal", {
          to: data.from,
          signal: { sdp: peerConnection.localDescription },
        });
      }
    } catch (e) {
      console.error("Erreur setRemoteDescription", e);
    }
  } else if (data.signal.candidate) {
    // C'est un candidat ICE
    try {
      // S'assurer que la connexion existe avant d'ajouter le candidat
      if (peerConnection) {
        await peerConnection.addIceCandidate(new RTCIceCandidate(data.signal.candidate));
      }
    } catch (e) {
      console.error("Erreur addIceCandidate", e);
    }
  }
});

// Gérer la déconnexion de l'autre utilisateur
socket.on("user-disconnected", (id) => {
  if (id === otherUserId) {
    console.log("L'autre utilisateur s'est déconnecté.");
    remoteVideo.srcObject = null;
    remoteVideoContainer.classList.add("hidden"); // Masquer le conteneur de la vidéo distante
    otherUserId = null;
    // Réinitialiser la connexion si l'autre pair se déconnecte
    if (peerConnection) {
      console.log("Fermeture de la connexion peer.");
      peerConnection.close();
      peerConnection = null;
    }
    // Afficher un message dans le chat
    const msg = document.createElement("div");
    msg.innerText = `[Système] L'utilisateur distant s'est déconnecté.`;
    messagesDiv.appendChild(msg);
    messagesDiv.scrollTop = messagesDiv.scrollHeight; // Scroll to bottom
  }
});

// --- Fonctions de contrôle audio/vidéo et raccrochage ---

muteAudioBtn.addEventListener('click', () => {
  if (localStream) {
    localStream.getAudioTracks().forEach(track => {
      track.enabled = !track.enabled;
      isAudioMuted = !track.enabled;
      muteAudioBtn.innerHTML = isAudioMuted ? '<i class="fas fa-microphone-slash"></i>' : '<i class="fas fa-microphone"></i>';
      muteAudioBtn.classList.toggle('bg-red-500', isAudioMuted);
      muteAudioBtn.classList.toggle('hover:bg-red-600', isAudioMuted);
      muteAudioBtn.classList.toggle('bg-blue-500', !isAudioMuted);
      muteAudioBtn.classList.toggle('hover:bg-blue-600', !isAudioMuted);
    });
  }
});

muteVideoBtn.addEventListener('click', () => {
  if (localStream) {
    localStream.getVideoTracks().forEach(track => {
      track.enabled = !track.enabled;
      isVideoMuted = !track.enabled;
      muteVideoBtn.innerHTML = isVideoMuted ? '<i class="fas fa-video-slash"></i>' : '<i class="fas fa-video"></i>';
      muteVideoBtn.classList.toggle('bg-red-500', isVideoMuted);
      muteVideoBtn.classList.toggle('hover:bg-red-600', isVideoMuted);
      muteVideoBtn.classList.toggle('bg-blue-500', !isVideoMuted);
      muteVideoBtn.classList.toggle('hover:bg-blue-600', !isVideoMuted);
    });
  }
});

hangupBtn.addEventListener('click', () => {
  // Fermer la connexion WebRTC
  if (peerConnection) {
    console.log("Fermeture de la connexion peer.");
    peerConnection.close();
    peerConnection = null;
  }
  // Arrêter les pistes du flux local
  if (localStream) {
    localStream.getTracks().forEach(track => track.stop());
    localStream = null;
  }
  localVideo.srcObject = null;
  // Masquer la vidéo distante et réinitialiser son srcObject
  remoteVideoContainer.classList.add("hidden");
  remoteVideo.srcObject = null;
  // Informer le serveur de la déconnexion (si ce n'est pas déjà fait par la fermeture de la page)
  socket.disconnect();
  // Rediriger vers la page d'accueil
  window.location.href = "/";
});

// Logique du chat (inchangée)
socket.on("chat-message", ({ username, message }) => {
  const msg = document.createElement("div");
  msg.innerText = `${username}: ${message}`;
  messagesDiv.appendChild(msg);
  messagesDiv.scrollTop = messagesDiv.scrollHeight; // Faire défiler vers le bas
});

sendBtn.onclick = () => {
  const msg = messageInput.value;
  if (msg.trim()) {
    socket.emit("chat-message", msg); // Envoyer le message au serveur
    // Afficher notre propre message dans le chat local
    const myMsg = document.createElement("div");
    myMsg.innerText = `Moi (${username}): ${messageInput.value}`; // Afficher le pseudo local
    messagesDiv.appendChild(myMsg);
    messagesDiv.scrollTop = messagesDiv.scrollHeight; // Scroll to bottom
    messageInput.value = "";
  }
};
