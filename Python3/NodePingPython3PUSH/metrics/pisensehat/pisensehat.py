#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""NodePing SenseHat PUSH module."""


from sense_hat import SenseHat
from os import popen
from re import findall
from . import config


def set_rotation(sense, degrees):
    """Set the orientation of text on the SenseHat."""
    sense.set_rotation(degrees)


def get_cpu_temp():
    """Get the processor's temperature."""
    result = popen("vcgencmd measure_temp").readline()
    return [float(num) for num in findall(r'[\d.]+', result)][0]


def collect_metrics(sense):
    """Collect and format metrics from the SenseHat sensors."""
    sense.clear()

    cpu_temp = get_cpu_temp()
    air_temp = sense.get_temperature_from_humidity()
    final_temp = air_temp - ((cpu_temp - air_temp) / config.TEMP_CALIBRATION)

    humidity = int(sense.get_humidity() + 10)
    sense.get_pressure()
    pressure = round(sense.get_pressure() * 0.02953, 2)

    if config.UNIT.upper() == "F":
        final_temp = int((final_temp*1.8) + 32)

    if config.LED_ON:
        if final_temp < config.MIN_OK_TEMP:
            t = [0, 0, 255]
        elif final_temp > config.MAX_OK_TEMP:
            t = [255, 0, 0]
        else:
            t = [0, 255, 0]

        if humidity < config.MIN_OK_HUM:
            h = [0, 0, 255]
        elif humidity > config.MAX_OK_HUM:
            h = [255, 0, 0]
        else:
            h = [0, 255, 0]

        if pressure < config.MIN_OK_PRESSURE:
            p = [0, 0, 255]
        elif pressure > config.MAX_OK_PRESSURE:
            p = [255, 0, 0]
        else:
            p = [0, 255, 0]

        o = [0, 0, 0]
        pixels = [
            o, o, o, o, o, h, o, h,
            o, o, o, o, o, h, h, h,
            t, t, t, o, o, h, o, h,
            o, t, o, o, o, o, o, o,
            o, t, o, o, o, p, p, p,
            o, o, o, o, o, p, o, p,
            o, o, o, o, o, p, p, o,
            o, o, o, o, o, p, o, o,
        ]
        sense.set_pixels(pixels)

    return {'temp': final_temp, 'humidity': humidity, 'pressure': pressure}


def main(system, logger):
    """Get the temp, humidity, and pressure from a Raspberry Pi SenseHat."""
    sense = SenseHat()
    set_rotation(sense, config.LED_ROTATION)

    return collect_metrics(sense)
