# pisensehat module

## Description

Uses the Raspberry Pi SenseHat module to collect temperature, humidity, and pressure.

This module also utilizes the LED array to show whether your configured values are too
high, too low, or just right:

Red for high
Green for good
Blue for low

## Configuration

LED_ON - Whether or not you want the LED array on the SenseHat to display info or not
LED_ROTATION - Rotate the LED array in 90 degree increments to align the array with the orientation of the Pi
UNIT - Celsius or Fahrenheit
MIN_OK_TEMP - Temperatures below this value will change the (T) on the LED array to blue
MAX_OK_TEMP - Temperatures above this value will change the (T) on the LED array to red

TEMP_CALIBRATION - The SenseHat is sensitive to the Raspberry Pi's CPU temps. Modify this value to match a known good thermometer in the room. Typically somewhere in the 1.0-1.5 range is common. Note that due to the Pi's impact on temperature values on the SenseHat, if your CPU load fluctuates a lot, it can have an impact on the accuracy of the SenseHat's output

MIN_OK_HUM - Humidity below this value will change the (H) on the LED array to blue
MAX_OK_HUM - Humidity above this value will change the (H) on the LED array to red

MIN_OK_PRESSURE - Pressure below this value will change the (P) on the LED array to blue
MAX_OK_PRESSURE - Pressure above this value will change the (P) on the LED array to red

## Testing TEMP_CALIBRATION

To calibrate your SenseHat to work well with your Raspberry Pi, it is good to adjust the
TEMP_CALIBRATION value and recheck it with a known good thermometer. This is to help offset
the heat coming from the Raspberry Pi. Note that this check will give fluctuating values if
your Pi has a fluctuating load. If you want consistent and reliable output, it is best not to
do arbitrary work on the Pi. And if you are increasing load, ensure that the temperatures are
consistent with another local thermometer from time to time. You can run the client like
`python3 NodePingPythonPUSH.py --showdata` to check the temperature outputs without submitting
data to NodePing. This will help in ensuring your SenseHat is calibrated.
