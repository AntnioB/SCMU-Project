

//ultrasound sensor
int trigPin = 12;    // TRIG pin
int echoPin = 14;    // ECHO pin
float duration_us, distance_cm;


//motor
int inM1 = 2;
int inM2 = 15;    //inM1 and inM2 control spin direction
int enM = 4;      //controls speed


void setup() {
  // put your setup code here, to run once:
  
  // begin serial port
  Serial.begin (9600);

  //ultrasound sensor
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);

  //motor
  pinMode(inM1, OUTPUT);
  pinMode(inM2, OUTPUT);
  pinMode(enM, OUTPUT);

  digitalWrite(inM1, LOW);
  digitalWrite(inM2, LOW);

}

void loop() {

  calculateDistance();

  if(distance_cm < 10){
    spin();
  }

  delay(1000);

}

int calculateDistance(){

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

}

void spin() {
  
  //max speed
  analogWrite(enM, 255);
  
  //spin clock-wise
  digitalWrite(inM1, LOW);
  digitalWrite(inM2, HIGH);

  Serial.print("Spining...");

  //spin for theses ms
  delay(5000);

  //turn motor off
  analogWrite(enM, 0);
  digitalWrite(inM1, LOW);
  digitalWrite(inM2, LOW);

}
