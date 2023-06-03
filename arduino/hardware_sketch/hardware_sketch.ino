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

//Define Firebase Data object
FirebaseData fbdo;

FirebaseAuth auth;
FirebaseConfig config;


//state
typedef enum {
  OFF, STANDBY, RESERVED, DISPENSING
} State;
State state = OFF;


//Bluetooth
BLEService dispenseService("19B10010-E8F2-537E-4F6C-D104768A1214"); // create service
BLEByteCharacteristic dispenseCharacteristic("19B10011-E8F2-537E-4F6C-D104768A1214", BLERead | BLEWrite); // create switch characteristic and allow remote device to read and write


//ultrasound sensor
int trigPin = 14;    // TRIG pin
int echoPin = 12;    // ECHO pin
float duration_us, distance_cm;


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

  //Network
  initNetwork();

  //LCD
  lcd.backlight();
  lcd.setCursor(0, 0);
  lcd.print("RangeMate");

  //ultrasound sensor
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);

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
      state_off();
      break;
    case STANDBY:
      state_standby();
      break;
    case RESERVED:
      state_reserved();
    case DISPENSING:
      state_dispensing();
      break;
  }
}

//OFF state represents when the machine was turned off or is out of ball for example
void state_off(){
  setColor(255,0,0);
  lcd.off();
  delay(1000);
}

//STANDBY state represents a on machine that is waiting to be reserved
void state_standby(){
  setColor(0,255,0);
  delay(1000);

  //quando ele for reservado faz BLE.advertise(); depois troca de estado
}

//RESERVED state represents a machine that has been reserved and is awating a blueetooth conection to begin normal operations
void state_reserved(){
  setColor(0, 0, 255);
}

//DISPENSING state represents a machine that is beeing used by the user
void state_dispensing(){
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

  /* Sign up */

  /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback; //see addons/TokenHelper.h
  
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
}
