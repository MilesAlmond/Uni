// Adjustable "Whack-a-mole" game with LEDs and sound!

const int ledPin1[] = {4,5,6}; //defining pin constants for each player's "moles"
const int ledPin2[] = {10,11,12};

const int playerOneButton = 2; //defining pin constants for the button inputs of each player
const int playerTwoButton = 3;

const int whiteLED1 = 9; //defining pin constants for LEDs that will flash when a "mole" is successfully hit
const int whiteLED2 = 13;

const int servopin = 7; //defining pin constant for the servo as well as pulse times that will turn the servo arm clockwise/anti-clockwise when a player succeeds
int pulse1 = 600;
int pulse2 = 1850;

const int potPin = A0; //defining pin constant for the potentiometer
const int speakerPin = A1; //defining pin constant for the piezo speaker

int score1 = 0; //defining each player's variable score and the constant max score
int score2 = 0;
const int maxScore = 10;

int delayTime;
int randNumber;

//setup interrupt, button input and LED outputs
void setup() {
  attachInterrupt(0, playerOneInput, FALLING); // specify interrupt routine
  for (int i=0; i < 3; i++){
    pinMode(ledPin1[i], OUTPUT);
  }
  
  attachInterrupt(1, playerTwoInput, FALLING);
  for (int i=0; i < 3; i++){
    pinMode(ledPin2[i], OUTPUT);
  }

  
  pinMode(playerOneButton, INPUT); //setting pin modes for each component as to whether it is input or output
  pinMode(playerTwoButton, INPUT);
  pinMode(whiteLED1, OUTPUT);
  pinMode(whiteLED2, OUTPUT);
  pinMode(servopin, OUTPUT);
  pinMode(potPin, INPUT);
  pinMode(speakerPin, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  delayTime = calculateDelayTime(); // calculates the delay time based on how high the potentiometer is turned up
  Serial.println(delayTime); // allows the developer to check the reading from the potentiometer
  
  randNumber = random(3); // select a random number
  
  digitalWrite(ledPin1[randNumber], HIGH); // light the LED with this number for player 1
  delay(delayTime); // turns on the LEDs for however long the delay time is set to
  
  digitalWrite(ledPin1[randNumber], LOW); // turn off the LED that has just turned on
  delay(delayBetweenLEDs());
  
  if(digitalRead(whiteLED1) == HIGH){ // if the white LED for player 1 is on, turn if off
    digitalWrite(whiteLED1, LOW);
    incrementPlayerOneScore(); // call a function that adds on to player 1's score
  }
  
  randNumber = random(3); // select another random number
  
  digitalWrite(ledPin2[randNumber], HIGH); // light the LED with this number for player 2
  delay(delayTime); // turns on the LEDs for however long the delay time is set to
  
  digitalWrite(ledPin2[randNumber], LOW); // turn off the LED that has just turned on
  delay(delayBetweenLEDs());
  
  if(digitalRead(whiteLED2) == HIGH){ // if the white LED for player 2 is on, turn if off
    digitalWrite(whiteLED2, LOW);
    incrementPlayerTwoScore(); // call a function that adds on to player 2's score
  }
}

int delayBetweenLEDs() {
  // wait between 0.3 and 1.3 seconds to turn another LED on
  return random(1000) + 300;
}

int calculateDelayTime() { // this function calculates a delay time based on the potentiometer reading
  int pot = analogRead(potPin); // reads the value from the potentiometer
  if(pot < 50) pot = 50; // if the potentiometer reading is 0 (i.e. turned up all the way), we'll make the delay time 50
  return pot * 0.9; // otherwise we'll make the delay time the potentiometer reading multiplied by 0.9
}

void writeToServo(int pulse) { // this function causes the servo to pulse either clockwise or anticlockwise to show which player is winning the game
  for(int i = 0; i < 2; i++) {
    digitalWrite(servopin, HIGH); // turns the servo on
    delayMicroseconds(pulse); // keeps the servo on for a tiny fraction of a second so that it rotates the correct direction/amount
    digitalWrite(servopin, LOW); // turns the servo back off
    delay(20); 
  }
}

void playTone(int Tone) { // this function plays a chosen tone from the piezo speaker of length 0.2 seconds
  tone(speakerPin, Tone, 200);
  delay(200);
}

void playWin() { // this function plays a specific victory tune from the speaker in the event that one of the players wins
  playTone(800);
  playTone(1000);
  playTone(1200);
  playTone(800);
  playTone(1600); 
}

void incrementPlayerOneScore() { // this function increases the score of player 1 if they have pressed their button in time
  score1++; // add 1 to their score
  int n = score1-score2; // define n to be the lead (or loss) of player 1
  if(n >= -2 && n <= 3) { // if player 1 is winning by at most 3 or losing by at most 2, turn the servo in player 1's favour
    writeToServo(pulse1); // NOTE: we don't continue turning the servo for a lead of 4 or more points due to keeping within a certain range of motion of the servo
  }
  if(score1 == maxScore) { // if player 1 has reached the max score, flash their LEDs, play the winning tune, and reset the servo and both scores
    flashLEDs(ledPin1); // call a function that flashes player 1's LEDS
    playWin(); // call a function that plays a winning tune
    delay(500);
    if(n < 3) { // if player 1 won by 1 or 2 points, turn the servo this amount of times in player 2's favour to reset the servo
      for (int i = 0; i < n; i++) {
        writeToServo(pulse2);
      }
    } else { // otherwise if player 1 won by 3 or more points, turn the servo 3 times in player 2's favour as this is the max it was turned in player 1's favour
     for (int i = 0; i < 3; i++) {
        writeToServo(pulse2); 
      }
    }
    score1 = 0; // reset both player's scores to 0 and now the game is ready to start again
    score2 = 0;
  }
}

void incrementPlayerTwoScore() { // this function increases the score of player 2 if they have pressed their button in time
  score2++; // add 1 to their score
  int n = score2-score1; // define n to be the lead (or loss) of player 2
  if(n >= -2 && n <= 3) { // if player 2 is winning by at most 3 or losing by at most 2, turn the servo in player 2's favour
    writeToServo(pulse2); // NOTE: we don't continue turning the servo for a lead of 4 or more points due to keeping within a certain range of motion of the servo
  }
  if(score2 == maxScore) { // if player 2 has reached the max score, flash their LEDs, play the winning tune, and reset the servo and both scores
    flashLEDs(ledPin2); // call a function that flashes player 2's LEDS
    playWin(); // call a function that plays a winning tune
    delay(500);
    if(n < 3) { // if player 2 won by 1 or 2 points, turn the servo this amount of times in player 1's favour to reset the servo
      for (int i = 0; i < n; i++) {
        writeToServo(pulse1);
      }
    } else { // otherwise if player 2 won by 3 or more points, turn the servo 3 times in player 1's favour as this is the max it was turned in player 2's favour
     for (int i = 0; i < 3; i++) {
        writeToServo(pulse1);
      }
    }
    score1 = 0; // reset both player's scores to 0 and now the game is ready to start again
    score2 = 0;
  }
}

void flashLEDs(int leds[]) { // this function turns on all LEDs of the winning player to signify their victory
  const int n = 3; // set how many LEDs there are to turn on, in this case there are 3
  const int d = 1000; // set how long the LEDs shall remain on for, in this case 1 second
  for(int i = 0; i < n; i++) { // for each LED, turn it on for the time specified above, then turn it off again
    digitalWrite(leds[i], HIGH);
  }
  delay(d);
  for(int i = 0; i < n; i++) {
    digitalWrite(leds[i], LOW);
  }
  delay(d);
}

void playerOneInput() { // this function is called whenever player 1 presses their button and checks to see if any of their "mole" LEDs were on at this point
  int total = 0; // starts total at 0
  for(int i = 0; i < 3; i++) { // individually check each LED and if it is on then add 1 to the total, turn on the white LED, and play a success tone
    if(digitalRead(ledPin1[i]) == HIGH) {
      total++;
      digitalWrite(whiteLED1, HIGH);
      playTone(2200);
    }
  }
    if(total == 0) { // if the total is still 0, this indicates none of the "mole" LEDs were on in which case play a failure tone
      playTone(400);
    }
}

void playerTwoInput() { // this function is called whenever player 2 presses their button and checks to see if any of their "mole" LEDs were on at this point
  int total = 0; // starts total at 0
  for(int i = 0; i < 3; i++) { // individually check each LED and if it is on then add 1 to the total, turn on the white LED, and play a success tone
    if(digitalRead(ledPin2[i]) == HIGH) {
      total++;
      digitalWrite(whiteLED2, HIGH);
      playTone(2200);
      }
    }
    if(total == 0) { // if the total is still 0, this indicates none of the "mole" LEDs were on in which case play a failure tone
     playTone(400);  
  }
}
