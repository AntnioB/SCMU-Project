
int trigPin = 12;    // TRIG pin
int echoPin = 14;    // ECHO pin

int motorPin = 25;   // MOTOR pin

float duration_us, distance_cm;

void setup() {
  // put your setup code here, to run once:
  
  // begin serial port
  Serial.begin (9600);

  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);

  pinMode(motorPin, OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:

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
      digitalWrite(motorPin, 1);
      delay(8000);
  }

  delay(1000);

}
