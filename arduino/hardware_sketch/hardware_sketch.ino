#include <Servo.h>
#include <LiquidCrystal_I2C.h>
#include <ArduinoBLE.h>
#include <Arduino.h>
#include <Ticker.h>
#include <WiFi.h>
#include <Firebase_ESP_Client.h>

//Provide the token generation process info.
#include "addons/TokenHelper.h"

//Provide the RTDB payload printing info and other helper functions.
#include "addons/RTDBHelper.h"

// Insert your network credentials
#define WIFI_SSID "NOWO-E2EAB"
#define WIFI_PASSWORD "3h27MEuB"

// Insert Firebase project API Key
#define API_KEY "AIzaSyD2fUFVGAvuK2PP3OOdUtGTI5JfN78GR2I"

#define USER_EMAIL "a.brejo@gmail.com"
#define USER_PASSWORD "Pass1234"
#define FIREBASE_PROJECT_ID "rangemate-392ab"

#define DEVICE_ID "19B10010-E8F2-537E-4F6C-D104768A1214"

//Define Firebase Data object
FirebaseData fbdo;

FirebaseAuth auth;
FirebaseConfig config;


//state
typedef enum {
  OFF,
  STANDBY,
  RESERVED, 
  DISPENSING
} State;

static const char *enum_to_string[] ={ 
    "OFF", 
    "STANDBY", 
    "RESERVED"
};

State state = STANDBY;


//Bluetooth
BLEService dispenseService(DEVICE_ID); // create service
BLEByteCharacteristic dispenseCharacteristic(DEVICE_ID, BLERead | BLEWrite); // create switch characteristic and allow remote device to read and write


//ultrasound sensor
int trigPin = 27;    // TRIG pin
int echoPin = 26;    // ECHO pin
float duration_us, distance_cm;
int trigPin2 = 14;
int echoPin2 = 12;
float duration2, distance2;


//servo
Servo servo;
int servo_pin = 13;


//led
int led_r = 19;
int led_g = 18;
int led_b = 5;


//LCD 
int lcdColumns = 16; //number of display columns
int lcdRows = 2; //number of display rows
LiquidCrystal_I2C lcd(0x27, lcdColumns, lcdRows); //creates the lcd 



void setup() {
  
  // begin serial port
  Serial.begin (9600);
  while(!Serial); 

  //Bluetooth
  if (!BLE.begin()) {
    Serial.println("starting BLE failed!");

    while (1);
  }
  BLE.setLocalName("RangeMate_1"); //set the local name peripheral advertises
  BLE.setAdvertisedService(dispenseService); //set the UUID for the service this peripheral advertises
  dispenseService.addCharacteristic(dispenseCharacteristic); //add the characteristics to the service
  BLE.addService(dispenseService);  //add the service
  dispenseCharacteristic.writeValue(0);
  BLE.advertise();

  //Network
  initNetwork();

  //LCD
  lcd.backlight();
  lcd.setCursor(0, 0);
  lcd.print("RangeMate");

  //ultrasound sensor
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  pinMode(trigPin2, OUTPUT);
  pinMode(echoPin2, INPUT);

  //servo
  servo.attach(servo_pin);

  //led 
  pinMode(led_r, OUTPUT);
  pinMode(led_g, OUTPUT);
  pinMode(led_b, OUTPUT);
  
}

void loop() {
  switch(state){
    case OFF:
    Serial.println("OFF");
      state_off();
      break;
    case STANDBY:
      Serial.println("STANDBY");
      state_standby();
      break;
    case RESERVED:
      Serial.println("RESERVED");
      state_reserved();
      break;
  }
  
}

//OFF state represents when the machine was turned off or is out of ball for example
void state_off(){
  updateStatus();
  setColor(255,0,0);
  lcd.noBacklight();
  delay(1000);
}

//STANDBY state represents a on machine that is waiting to be reserved
void state_standby(){
  setColor(0,0,255);

  BLE.poll();

  boolean connected = (dispenseCharacteristic.value() != 0);

  if(connected && BLE.connected()){
    state = RESERVED;
    delay(1000);
  }
  
  //quando ele for reservado faz BLE.advertise(); depois troca de estado
}

//RESERVED state represents a machine that has been reserved and is awating a blueetooth conection to begin normal operations
void state_reserved(){
  setColor(0, 255, 0);

  BLE.poll();

  boolean disconnected = (dispenseCharacteristic.value() != 1);

  if(disconnected || !BLE.connected()){
    state = STANDBY;
    dispenseCharacteristic.writeValue(0);
    delay(1000);

  }

  checkForMovement();
  delay(1000);
}

void checkForMovement(){
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2); // wait for 2 ms to avoid collision in serial monitor

  // generate 10-microsecond pulse to TRIG pin
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  // measure duration of pulse from ECHO pin
  duration_us = pulseIn(echoPin, HIGH);

  // calculate the distance
  distance_cm = 0.017 * duration_us;

  // print the value to Serial Monitor
  Serial.print("distance: ");
  Serial.print(distance_cm);
  Serial.println(" cm");

  if(distance_cm < 10){
    spin();
    delay(3000)
    checkForBalls();
  }
}

void checkForBalls(){
  digitalWrite(trigPin2, LOW);
  delayMicroseconds(2); // wait for 2 ms to avoid collision in serial monitor

  // generate 10-microsecond pulse to TRIG pin
  digitalWrite(trigPin2, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin2, LOW);

  // measure duration of pulse from ECHO pin
  duration2 = pulseIn(echoPin2, HIGH);

  // calculate the distance
  distance2 = 0.017 * duration2;

  // print the value to Serial Monitor
  Serial.print("ballDistance: ");
  Serial.print(distance2);
  Serial.println(" cm");

  if(distance2 > 6){
    //sendNotification()
  }
}

void spin() {
  setColor(255, 255, 0);
  lcd.clear();
  Serial.println("Spinning...");
  lcd.print("Spinning...");
  servo.write(180);
  delay(1000);
  servo.write(0);
  lcd.clear();
}

void setColor(int redValue, int greenValue, int blueValue) {
  analogWrite(led_r, 255-redValue);
  analogWrite(led_g, 255-greenValue);
  analogWrite(led_b, 255-blueValue);
}

void initNetwork(){
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED){
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  /* Assign the api key (required) */
  config.api_key = API_KEY;

  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;

  /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback; //see addons/TokenHelper.h
  
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
}

void updateStatus(){
  if (Firebase.ready()){
    String path = "/devices/19B10010-E8F2-537E-4F6C-D104768A1214/";

    FirebaseJson content;

    content.set("fields/status/stringValue", String(enum_to_string[state]).c_str());
    content.set("fields/hasBalls/booleanValue", String(true).c_str());
    
    // Write an Int number on the database path test/int
    if (Firebase.Firestore.patchDocument(&fbdo, FIREBASE_PROJECT_ID,"", path.c_str(), content.raw(), "")){
      Serial.println("PASSED");
      Serial.println("PATH: " + fbdo.dataPath());
      Serial.println("TYPE: " + fbdo.dataType());
    }
    else {
      Serial.println("FAILED");
      Serial.println("REASON: " + fbdo.errorReason());
    }
  }
}
