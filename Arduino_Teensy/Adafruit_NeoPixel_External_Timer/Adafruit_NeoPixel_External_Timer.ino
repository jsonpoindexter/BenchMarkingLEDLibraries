
#include <Adafruit_NeoPixel.h>
// Which pin on the Arduino is connected to the NeoPixels?
#define PIN            3
// How many NeoPixels are attached to the Arduino?
#define NUMPIXELS      128
Adafruit_NeoPixel strip = Adafruit_NeoPixel(NUMPIXELS , PIN, NEO_GRB + NEO_KHZ800);;


void setup(void) 
{
  Serial.begin(115200);
  strip.begin();
  strip.show(); // Initialize all pixels to 'off'
  delay(2000);
}
 
byte Start = 0; // start byte is dec 0
byte Stop = 1; // stop byte is dec 1
int maxLoops = 100;
int postDelay = 100; //delay after the Stop byte gets sent in order to give Processing time to be ready for next Start signal
void loop(void) 
{
  Serial.write(Start);
  for(int loopCount = 0; loopCount < 100; loopCount++){
    for(int i = 0; i < NUMPIXELS; i++){
       strip.setPixelColor(i, color(map(i,0,NUMPIXELS,1,384),1));
    }
    strip.show();
  }
  Serial.write(Stop);
  delay(postDelay);
}


// Color 1 from 384; brightness 0.0 to 1.0.
uint32_t color(uint16_t color, float brightness)  {
  byte r, g, b;
  int range = color / 128;
  switch (range) {
    case 0: // Red to Yellow (1 to 128)
      r = 127 - color % 128;
      g = color % 128;
      b = 0;
      break;
    case 1: // Yellow to Teal (129 to 256)
      r = 0;
      g = 127 - color % 128;
      b = color % 128;
      break;
    case 2: // Teal to Purple (257 to 384)
      r = color % 128;
      g = 0;
      b = 127 - color % 128;
      break;
  }
  r *= brightness;
  g *= brightness;
  b *= brightness;
  return strip.Color(r, g, b);
}

