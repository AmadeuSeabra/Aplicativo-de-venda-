const admin = require('firebase-admin');
const functions = require('firebase-functions');

admin.initializeApp();

// Função para enviar notificação push
exports.sendCommentNotification = functions.firestore
  .document('comments/{commentId}')
  .onCreate(async (snapshot, context) => {
    const commentData = snapshot.data();

    if (!commentData) return;

    // Obter o ID do usuário que possui a postagem
    const userId = commentData.userId; // Assumindo que você salva isso ao criar o comentário
    const userDoc = await admin.firestore().collection('users').doc(userId).get();

    if (!userDoc.exists || !userDoc.data().fcmToken) {
      console.log('Usuário não encontrado ou sem FCM token.');
      return;
    }

    const fcmToken = userDoc.data().fcmToken;

    // Configuração da notificação
    const message = {
      notification: {
        title: `Novo comentário na sua postagem!`,
        body: commentData.comment,
      },
      token: fcmToken,
    };

    // Enviar notificação
    try {
      await admin.messaging().send(message);
      console.log('Notificação enviada com sucesso:', message);
    } catch (error) {
      console.error('Erro ao enviar notificação:', error);
    }
  });
