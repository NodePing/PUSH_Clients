#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""NodePing DHT22 PUSH module."""

import adafruit_dht
from time import sleep
from . import config

def main(system, logger):
    """Get the temp, humidity, from DHT22 sensor."""

    pin = config.PIN
    device = adafruit_dht.DHT22(pin)
    environment = {}

    while True:
        try:
            temperature = device.temperature
            humidity = device.humidity

            device.exit()
        except Exception as err:
            logger.error('metrics.pidht22: {err}!'.format(**locals()))
            sleep(2)
            continue
        else:
            break
    
    if humidity is not None:
        environment.update({"humidity": int(humidity)})
    if temperature is not None:
        if config.UNIT.upper() == "F":
            return_temp = int((temperature*1.8) + 32)
        else:
            return_temp = temperature

        environment.update({"temperature": round(return_temp, 2)})

    return environment
