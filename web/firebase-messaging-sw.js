importScripts('https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js');

firebase.initializeApp({
  apiKey: "AIzaSyBkVk3l1DpqvoPmrhrR_lOMgXlJtb4VWhE",
  authDomain: "vfix4u-42216.firebaseapp.com",
  projectId: "vfix4u-42216",
  storageBucket: "vfix4u-42216.firebasestorage.app",
  messagingSenderId: "125949822411",
  appId: "1:125949822411:web:6f69a97dfb8e2137dea24e",
  measurementId: "G-5CWKM48VHF"
});

const messaging = firebase.messaging();

messaging.setBackgroundMessageHandler(function(payload) {
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/favicon.png'
  };
  return self.registration.showNotification(notificationTitle, notificationOptions);
});

self.addEventListener('notificationclick', function(event) {
  event.notification.close();
  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true })
      .then(function(clientList) {
        if (clientList.length > 0) {
          clientList[0].focus();
        } else {
          clients.openWindow('/');
        }
      })
  );
});
