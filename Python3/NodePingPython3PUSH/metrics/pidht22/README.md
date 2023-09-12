# pidht22 module

## Description

Use the DHT22 sensor with the Raspberry Pi

Sensor tested: HiLetgo 2pcs DHT22/AM2302 Digital Temperature And Humidity Sensor

## Configuration

UNIT - Set to "F" for Fahrenheit or "C" for Celsius
PIN - By default this is pin 7, or GPIO 4 on the Raspberry Pi. If using a different pin, consult the documentation

An example of connecting the sensor to the Pi:

* Sensor left pin to pin 2 (5V power) on the Pi
* Sensor middle pin to pin 7 (GPIO 4) on the Pi
* Sensor right pin to pin 9 (Ground) on the Pi

Pi pin layout: https://www.raspberrypi.com/documentation/computers/raspberry-pi.html
board module: https://learn.adafruit.com/arduino-to-circuitpython/the-board-module
