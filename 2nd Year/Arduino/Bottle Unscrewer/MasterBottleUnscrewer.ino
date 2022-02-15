#include <Wire.h> // including this library allows us to communicate with I2C between the Arduino boards

const int lightsensorPin = A0; // inititalising pin number and variable with respect to the photoresistor (light sensor)
int lightValue; // this is the brightness of the light received by the light sensor (the higher the value the brighter the light) 

const int trigPin = 9; // initialising pin numbers and variables with respect to the ultrasonic sensor (HC-SR04)
const int echoPin = 10;
long duration; // this variable gives the time taken for the soundwave ping to travel out and back in to the ultrasonic sensor
int distance; // this variable gives the distance away in cm of the object in front of the ultrasonic sensor

const int redLED = 12; // initialising pin numbers with respect to the LEDs
const int greenLED = 13;

void setup() {
Wire.begin(); // this initiates the "wire" library and, as the address parameter is empty, joins the I2C bus as a master
pinMode(lightsensorPin, INPUT); // initialising pin modes (input or output) of all the components used for this Arduino
pinMode(trigPin, OUTPUT);
pinMode(echoPin, INPUT);
pinMode(redLED, OUTPUT);
pinMode(greenLED, OUTPUT);
Serial.begin(9600); // initialising the serial monitor for testing purposes
}

void loop() { // this function loops round constantly
lightValue = analogRead(lightsensorPin); // setting the light value read by the light sensor 
Serial.print("Light: "); // printing this value in the serial monitor
Serial.print(lightValue);
Serial.print("\t \t");
  if (distance < 100) { // printing the distance value read by the ultrasonic sensor provided it's within a reasonable range
Serial.print("Distance: ");
Serial.println(distance);
Serial.println();
  }
bottlePlaced(); // calling a function that checks if the light sensor value is sufficiently low enough to suggest a bottle has been placed upon the stand
delay(500); // this entire loop will repeat (and therefore update variables and serial monitor values) every 0.5 seconds
}

void bottlePlaced(){ 
  if (lightValue < 300 && lightValue > 0) { // if the light value exists and is below our specified brightness of 300, then this function is carried out
  digitalWrite(redLED,HIGH); // turns on the red LED to show the user the light sensor has been triggered
  delay(2000); // waits 2 seconds before calling a function that will check the distance to an object (if any) on the stand (this delay is useful in preventing the task accidentally being triggered, for example by someone simply waving their hand over the sensor) 
  checkDistance();
  }
}
  
void checkDistance(){
  digitalWrite(trigPin, LOW); // sends out a soundwave ping from the ultrasonic sensor to check the distance to an object (if any) on the bottle stand
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  duration = pulseIn(echoPin, HIGH); // the echo pin picks the soundwave back up, and the time (in microseconds) from when it was sent to when it is returned is calculated
  distance = duration * 0.034/2; // calculates the distance in cm using the speed of sound (340m/s)
  bottleAvailable(); // calls a function that could initiate the bottle opening procedure
}

void bottleAvailable(){
  if(distance < 10){ // if the distance found is less than 10cm (i.e. there is indeed an object on the stand) then this function is carried out
  digitalWrite(greenLED, HIGH); // turns on the green LED to show the user the ultrasonic sensor has found a critical value and the procedure will begin
  Wire.beginTransmission(8); // begins a transmission to the "Slave" Arduino with the given address, we are using '8' for the slave address in this case
  Wire.write(distance); // sends a byte of the distance to this Arduino
  Wire.endTransmission(); // ends the transmission
  delay(10000); // provides a 10 second delay to allow the "Slave" Arduino to carry out the procedure and the bottle to be removed before the "Master" Arduino continues to take readings 
  digitalWrite(redLED, LOW); // turns both the red and green LEDs off to show the user that the Arduinos have reset and that they are ready for another bottle to be placed
  digitalWrite(greenLED, LOW);
  }
  else{
    digitalWrite(redLED, LOW); // if the distance is too far away then do nothing except turn off the red LED so that we reset back to the beginning
  }
}
