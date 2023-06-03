#ifndef Network_H
#define Network_H

#include <WiFi.h>
#include <Firebase_ESP_Client.h>

class Network{
    private:
        FirebaseData fbdo;
        FirebaseAuth auth;
        FirebaseConfig config;

        void firebaseInit();
        friend void WifiEventConnected(WiFiEvent_t event, WiFiEventInfo_t info);
        friend void WiFiEventDisconnected(WiFiEvent_t event, WiFiEventInfo_t info);
        friend void WiFiEventGotIP(WiFiEvent_t event, WiFiEventInfo_t info);
        friend void FirestoreTokenStatusCallback(TokenInfo info);

    public:
        Network(void);
        void initWiFi();
        void firestoreDataUpdate(double temp, double humi);
};

#endif