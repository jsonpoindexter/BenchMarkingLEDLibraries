import processing.serial.*;

int numPorts=0;  // the number o
int maxPorts=24; // maximum number of serial ports

Serial[] mySerial = new Serial[maxPorts];     // each port's actual Serial port
boolean[] ledLayout = new boolean[maxPorts];   // layout of rows, true = even is left->right
int errorCount=0;

void setup() {
  String[] list = Serial.list();
  delay(20);
  println("Serial Ports List:");
  println(list);
  serialConfigure("COM4");  // change these to your port names
  if (errorCount > 0) exit();

}

byte Start = 0; // start byte is 00000000
byte Stop = 1; // stop byte is  00000001
long startTime = 0;
long stopTime = 0;
long totalTime = 0;

int loopCount = 0;
final int maxLoops = 100; // how many times we want to loop before getting an average
float [] aveArray = new float[maxLoops]; // array to hold all the totalTime values 


void draw()
{
  byte[] inBuffer = new byte[1];
  while ( mySerial[0].available() > 0) {
    inBuffer = mySerial[0].readBytes();
    mySerial[0].readBytes(inBuffer);
    if (inBuffer != null) {
       byte inBuf = inBuffer[0];
      if(inBuf == Start ){
        startTime = millis();
      }
      if(inBuf == Stop){
        stopTime = millis();
        totalTime = stopTime - startTime;
        aveArray[loopCount] = totalTime;
        print(loopCount);print(" : ");println(totalTime);
        loopCount++;
        if(loopCount == maxLoops){
          print("average : ");println(arrayAverage(aveArray));
          loopCount = 0;
        }
      }
     }
   } 
}


static final float arrayAverage(float... arr) {
  float sum = 0;
  for (float f: arr)  sum += f;
  return sum/arr.length;
}

// helps for setting up serial port
void serialConfigure(String portName) {
  if (numPorts >= maxPorts) {
    println("too many serial ports, please increase maxPorts");
    errorCount++;
    return;
  }
  try {
    mySerial[numPorts] = new Serial(this, portName, 115200);
    if (mySerial[numPorts] == null) throw new NullPointerException();
    mySerial[numPorts].write('?');
  } catch (Throwable e) {
    println("Serial port " + portName + " does not exist or is non-functional");
    errorCount++;
    return;
  }
  delay(50);
  // only store the info and increase numPorts if Teensy responds properly
  numPorts++;
}


