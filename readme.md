# Fugidaire LEDs controller

LUA firmware for the WS2812 LED driver for the fugidaire

Provides an MQTT endpoint to change the colour of the LED strips fitted under
the taps and shelves of the Fugidaire. In addition to this, we will also use
some GPIOs to turn the cooling fans on and off

## How to use

First, make a copy of the `settings_default.lua` file to `settings.lua`.
You can then edit this file with your own settings to connect to your mqtt server.
Currently the four LED segments (see below) are hard-coded, but I'm planning to 
re-write the code to read the segment names and lengths from the config file
as well.

## LEDs

There are four segments of LED strips, connected in series, in the following
order:

  - Tower (under the taps), 28 LEDs
  - Front segment of right shelf
  - Rear segment of full shelf
  - Front segment of left shelf

They are connected left to right (as viewed from the front of the device),
except for the full shelf lighting at the rear, which goes right to left.

## Fans

Three fans can be controlled via MQTT.

  - Tower cold, blows cold air up onto the taps
  - Tower warm, blows warm air back down into the freezer
  - Freezer cooling, circulates air around the freezer exterior

These are simply connected to 12V via a MOSFET which is driven by three GPIO
pins on the ESP8266.

## Temperature / Humidity

If time permits, I might add some sensors to monitor the temperatures. Values
of interest would be the freezer interior, temperature of a keg, air into the
tower, and air going back into the freezer.