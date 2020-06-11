#include <Audio.h>
#define MICGAIN 50

// GUItool: begin automatically generated code
AudioInputPDM            mic;            
AudioOutputAnalogStereo  dacs1;         
AudioConnection          patchCord1(mic, 0, dacs1, 1);
AudioConnection          patchCord2(mic, 0, dacs1, 0);
AudioAnalyzePeak peak1;
AudioAnalyzeRMS rms1;
AudioConnection p1(mic, peak1);
AudioConnection p2(mic, rms1);
AudioOutputUSB            usb1;
AudioConnection patchCord3(mic, 0, usb1, 1);
AudioConnection patchCord4(mic, 0, usb1, 0);
// GUItool: end automatically generated code

void setup() {
  AudioMemory(80);
  analogReference(INTERNAL);
  Serial.begin(9600);
}

void loop() {
  Serial.print(MICGAIN * rms1.read()); Serial.print(" ");
  Serial.println(MICGAIN * peak1.read());
  delay(5);
}
