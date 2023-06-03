#include "Network.h"
#include "addons/TokenHelper.h"
#define WIFI_SSID "NOWO-E2EAB"
#define WIFI_PASSWORD "3h27MEuB"

#define API_KEY "AIzaSyD2fUFVGAvuK2PP3OOdUtGTI5JfN78GR2I"
#define FIREBASE_PROJECT_ID "rangemate-392ab"
#define USER_EMAIL "device1@gmail.com"
#define USER_PASSWORD "Pass1234"

static Network *instance = NULL;
Network::Network(){
    instance = this;
}

void WiFiEventConnected(WiFiEvent_t event, WiFiEventInfo_t info){
    Serial.println("WiFi connected, awaiting IP");
}

void WiFiEventDisconnected(WiFiEvent_t event, WiFiEventInfo_t info){
    Serial.println("WiFi disconnected");
}

void WiFiEventGotIP(WiFiEvent_t event, WiFiEventInfo_t info){
    Serial.println("Local IP:");
    Serial.println(WiFi.localIP());
    instance->firebaseInit();
}

void FirestoreTokenStatusCallback(TokenInfo info){
  Serial.printf("Token Info: type = %s, status = %s\n", getTokenType(info), getTokenStatus(info));
}

void Network::initWiFi(){
    WiFi.disconnect();
    WiFi.onEvent(WiFiEventConnected, ARDUINO_EVENT_WIFI_STA_CONNECTED);
    WiFi.onEvent(WiFiEventGotIP, ARDUINO_EVENT_WIFI_STA_GOT_IP);
    WiFi.onEvent(WiFiEventDisconnected, ARDUINO_EVENT_WIFI_STA_DISCONNECTED);
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
}

void Network::firebaseInit(){
    config.api_key = API_KEY;

    auth.user.email = USER_EMAIL;
    auth.user.password = USER_PASSWORD;

    config.token_status_callback = FirestoreTokenStatusCallback;

    Firebase.begin(&config, &auth);
}

void Network::firestoreDataUpdate(double temp, double humi){
    if(WiFi.status() == WL_CONNECTED && Firebase.ready()){
        String path = "/sensors/1";

        FirebaseJson content;

        content.set("fields/temperature/doubleValue", String(temp).c_str());
        content.set("fields/humidity/doubleValue", String(humi).c_str());

        if(Firebase.Firestore.createDocument(&fbdo, FIREBASE_PROJECT_ID, "", path.c_str(), content.raw())){
            Serial.printf("ok\n%s\n\n", fbdo.payload().c_str());}
        else {
            Serial.printf("error\n%s\n\n", fbdo.errorReason().c_str());
        }
    }
}