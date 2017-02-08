'''
-------------------------------------------
Name: Strawbretty
-------------------------------------------
Using the OLED driver and IMU
-------------------------------------------
'''

import pyb
from pyb import LED, ADC, Pin
from oled_938 import OLED_938
from mpu6050 import MPU6050

# Create peripheral objects
b_led = LED(4)
imu = MPU6050(1, False)

# I2C connected to Y9, Y10, (I2C bus 2) and Y11 is reset low active
oled = OLED_938(pinout={'sda': 'Y10', 'scl': 'Y9', 'res': 'Y8'}, height=64, external_vcc=False, i2c_devid=61)

oled.poweron()
oled.init_display()

width = 128
message = 'Bluberry'
length = len(message)*6
offset = (width-length)/2
# Simple hello world message
oled.draw_text(int(offset),0,message) # 6x8 per letter


while True:
    b_LED.toggle()

    pitch = imu.pitch( ) # Returns the pitch angle in degrees.
    gy_dot = imu.get_gy( ) # Returns d(pitch)/dt in degrees/sec.

    roll = imu.roll( ) # Returns the roll angle in degrees.
    gx_dot = imu.get_gx( ) # Returns d(roll)/dt in degrees/sec.


    oled.draw_text(0,20,'Pitch angle:{:6.3f}'.format(pitch) )
    oled.draw_text(0,40,'Pitch rate:{:6.3f}'.format(gy_dot) )
    tic = pyb.millis() # start time
    oled.display()
    pyb.delay(100) # delay by random numner of millisec
