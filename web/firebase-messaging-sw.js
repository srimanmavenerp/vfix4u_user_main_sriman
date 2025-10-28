importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
    apiKey: "AIzaSyC2mUsQqp94796LvzJlKSyyBxEmAIpsZlU",
            authDomain: "vfix4u-42216.firebaseapp.com",
            projectId: "vfix4u-42216",
            storageBucket: "vfix4u-42216.firebasestorage.app",
            messagingSenderId: "125949822411",
            appId: "1:125949822411:web:6f69a97dfb8e2137dea24e",
            measurementId: "G-5CWKM48VHF"
});

const messaging = firebase.messaging();

messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            const title = payload.notification.title;
            const options = {
                body: payload.notification.score
              };
            return registration.showNotification(title, options);
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});