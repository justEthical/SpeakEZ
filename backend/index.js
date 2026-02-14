const admin = require('firebase-admin');
const fs = require('fs');
const serviceAccount = require('./service-account.json');

// Initialize with full admin privileges
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

// Find all user documents where isSupportsOndeviceTranscription.isSupportsOndeviceTranscription is "true" (string)
async function getDocsWithStringTrueTranscription() {
  try {
    const usersRef = db.collection('users');
    const snapshot = await usersRef
      .where('isSupportsOndeviceTranscription.isSupportsOndeviceTranscription', '==', true)
      .get();

    if (snapshot.empty) {
      console.log('No documents found with isSupportsOndeviceTranscription as string "true"');
      return [];
    }


    const docs = [];
    snapshot.forEach(doc => {
      docs.push({ id: doc.id, ...doc.data() });
      console.log('Found document:', doc.id);
    });

    console.log(`Total documents found: ${docs.length}`);

    // Save results to output.json
    fs.writeFileSync('output.json', JSON.stringify(docs, null, 2));
    console.log('Results saved to output.json');

    return docs;
  } catch (error) {
    console.error('Error fetching documents:', error);
    throw error;
  }
}

// --- Run the functions ---
async function main() {
  await getDocsWithStringTrueTranscription();

  // Important: Node scripts don't always exit automatically with Firebase
  process.exit();
}

main();