#include <Wire.h> // including this library allows us to communicate with I2C between the Arduino boards
#include <Servo.h> // including this library allows us to control the servo, and position it between angles of 0 and 180 degrees

Servo myServo; // initialising a name for the servo we shall be using

int pos = 0; // initialising variables (setting servo to 0 degrees position)
int x;

int piezoPin = A2; // initialising pin numbers for the piezo speaker and the motor respectively
int motorPin = 9;

void setup() {
  Wire.begin(8); // this initiates the "wire" library and joins the I2C bus as a slave with address 8
  Wire.onReceive(receiveEvent); // calls the function receiveEvent when this slave receives a transmission from the master Arduino
  
  myServo.attach(3); // attaches the servo to pin 3
  
  pinMode(motorPin, OUTPUT); // initialising pin modes (input or output) of the motor and piezo speaker respectively
  pinMode(piezoPin, OUTPUT);
}

void loop() {
  openAndReset(); // every 0.05 seconds, attempts to carry out the openAndReset function
  delay(50);
}

void receiveEvent(int howMany){ // the parameter for this function is simply how many bytes are received from the master Arduino (in our case it will always be 1)  
  x = Wire.read(); // we first set "x" to be whatever is received from the master Arduino (this will be a distance to the bottle upon the stand)
  if(x != 0 && x < 10){ // if this distance exists and is less than 10 cm, we carry out a for loop
    for(pos; pos <= 70; pos++){ // this function moves the servo arm 70 degrees clockwise
      delay(20);
      myServo.write(pos);
    }

  }
 
}

void openAndReset(){ // this function will turn on the motor to open the bottle, as well as play a tune to let the user know that the process is complete
  if(pos != 0){ // the function is carried out if the servo arm has moved
    delay(1000); // waits a second before starting to allow the arm to settle
    digitalWrite(motorPin, HIGH); // turns on the motor (anticlockwise) for 3 seconds and then does nothing for a further 3 seconds
    delay(3000);
    digitalWrite(motorPin, LOW);
    delay(3000);
    pos = 0; // resets the servo arm to 0 degrees then waits a further 3 seconds
    myServo.write(pos);
    delay(3000);
    tone(piezoPin, 400, 500); // using the built in Arduino "tone" function, we play a two-tone melody that suggests to the user that they can now remove their successfully opened bottle from the stand
    delay(500);
    tone(piezoPin, 600, 500);
    x = 0; // resets "x" (i.e. the distance received from the master Arduino) to 0
  }
}
