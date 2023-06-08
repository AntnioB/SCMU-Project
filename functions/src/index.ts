/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import functions = require("firebase-functions");
import admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// export const helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });


export const sendNotificationToTopic =
functions.firestore.document("devices/{uid}").onUpdate(async (event) =>{
    const deviceId = event.after.id;
    const data = event.after.get("hasBalls");

    if (!data) {
    const message ={
        notification: {
            title: "Alert",
            body: deviceId + " has run out of balls",
        },
        topic: "manager",
    };

    const response = await admin.messaging().send(message);
    console.log(response);
    }
});
