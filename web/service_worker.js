const CACHE_NAME = 'flutter-app-cache-v1.1';
const urlsToCache = [
  '/',
  '/index.html',
  '/main.dart.js',
  '/styles.css',
  '/assets/images',
  '/assets/language'
];

// Install event - cache assets
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then((cache) => {
        return cache.addAll(urlsToCache);
      })
  );
});

// Fetch event - respond with cached assets or fetch from network
self.addEventListener('fetch', (event) => {
  event.respondWith(
    caches.match(event.request)
      .then((response) => {
        // Return cached response if available, otherwise fetch from network
        return response || fetch(event.request);
      })
  );
});

// Activate event - clear old caches
self.addEventListener('activate', function(event) {
  const cacheWhitelist = ['your-cache-name']; // Specify your cache name here.
  event.waitUntil(
    caches.keys().then(function(cacheNames) {
      return Promise.all(
        cacheNames.map(function(cacheName) {
          if (cacheWhitelist.indexOf(cacheName) === -1) {
            // Delete old cache if it's not in the whitelist
            return caches.delete(cacheName);
          }
        })
      );
    })
  );
});
