const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendGymPing = functions.https.onCall(async (data, context) => {
  const friendId = data.friendId;
  const snapshot = await admin.firestore().collection('users').doc(friendId).get();

  if (!snapshot.exists) {
    throw new functions.https.HttpsError('not-found', 'Friend not found');
  }

  const fcmToken = snapshot.data().fcmToken;
  if (!fcmToken) {
    throw new functions.https.HttpsError('failed-precondition', 'User has no FCM token');
  }

  const message = {
    notification: {
      title: 'Gym Ping 💪',
      body: 'Hey, I’m at the gym!'
    },
    token: fcmToken
  };

  await admin.messaging().send(message);
  return { success: true };
});
