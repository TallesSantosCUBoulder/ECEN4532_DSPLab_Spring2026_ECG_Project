#include "TimerOne.h"

unsigned long adcDelay = 3000; // delay 3000us or 3ms *(sampling rate fs)
int adcCounter = 0;            // counting buffer index
int count_aux = 0;             // debug var.

const int BuffSize = 1;       // size buffer
int BufferVec[BuffSize] = {0}; // buffer

char str_aux[6];                // each number is defined as a string "XXXX\n", where X is a digit [0:9]

void send_buffer(){  // function to send buffer vec data using serial port

  for(int i=0;i<BuffSize;i++){
    sprintf (str_aux, "%04d\n", BufferVec[i] );
    Serial.print(str_aux);
  }

}

void readADC() {  // function to read the analog input each 1/fs secs.
  BufferVec[adcCounter] = analogRead(A0);

  // debug
  //BufferVec[adcCounter] = count_aux ;
  //count_aux = (count_aux+1)%9999 ;

  adcCounter++;
  if(adcCounter >= BuffSize){
    adcCounter = 0;
    send_buffer();
  }

}


void setup() {
  Serial.begin(115200);                    // set the baud rate
  Serial.println("INITIALIZING ARDUINO");
  delay(1000);
  pinMode(A0, INPUT);                      // set A0 as the pin input
  Timer1.initialize(adcDelay);
  Timer1.attachInterrupt(readADC);
}

void loop() {
// empty
}
