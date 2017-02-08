'''
-------------------------------------------
Name: Ben Greenberg & Clarisse Bret
-------------------------------------------
Learning to use the OLED display driver
-------------------------------------------
'''

import pyb
from pyb import LED, ADC, Pin
from oled_938 import OLED_938

# Create peripheral objects
b_led = LED(4)
pot = ADC(Pin('X11')) # this is the variable resistor (potentiometer) connected to pin X11 on the pyboard

# I2C connected to Y9, Y10, (I2C bus 2) and Y11 is reset low active. This creates the oled object.
oled = OLED_938(pinout={'sda': 'Y10', 'scl': 'Y9', 'res': 'Y8'}, height=64, external_vcc=False, i2c_devid=61)

oled.poweron()
oled.init_display()

width = 128 # screen width in pixels
message = 'Blueberry'
# Each character 6 in width, 8 in height
length = len(message)*6 # length of message in pixels
offset = int( (width-length)/2 ) # finds buffer required either side to centre message. Offset must be an integer number of pixels
oled.draw_text(offset,0,message)

tic = pyb.millis() # gets current time
while True:
    b_LED.toggle()
    toc = pyb.millis() # read elapsed time
    oled.draw_text(0,20,'Delay time:{:6.3f}sec'.format((toc-tic)*0.001))
    oled.draw_text(0,40,'POT5K reading:{:5d}'.format(pot.read()))
    tic = pyb.millis() # start time
    oled.display()
    delay = pyb.rng()%1000 # generates random number btw 0 and 999
    pyb.delay(delay) # delay by random numner of millisec
