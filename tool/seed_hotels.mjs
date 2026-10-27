// Copies tool/hotels.json into the Firestore `hotels` collection.
//
// Optional: the app shows the bundled hotels while the collection is empty.
// Use this when you want to edit hotels in the Firebase console.
//
//   dart run tool/export_hotels.dart
//   cd tool && npm install firebase-admin
//   GOOGLE_APPLICATION_CREDENTIALS=/path/to/service-account.json \
//     node seed_hotels.mjs <project-id>
//
// Create the service account key in Firebase console -> Project settings ->
// Service accounts. Never commit it.
import { readFileSync } from 'node:fs';
import { initializeApp, applicationDefault } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';

const projectId = process.argv[2];
if (!projectId) {
  console.error('Usage: node seed_hotels.mjs <project-id>');
  process.exit(1);
}

const hotels = JSON.parse(readFileSync(new URL('./hotels.json', import.meta.url), 'utf8'));

initializeApp({ credential: applicationDefault(), projectId });
const batch = getFirestore().batch();
for (const [id, data] of Object.entries(hotels)) {
  batch.set(getFirestore().collection('hotels').doc(id), data);
}
await batch.commit();
console.log(`Saved ${Object.keys(hotels).length} hotels to ${projectId}.`);
