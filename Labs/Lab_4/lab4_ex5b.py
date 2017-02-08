'''
NAME: Lab 4 Exercise 5
AUTHORS: Benedict Greenberg and Clarisse Bret
DATE: 8 Feb 2017
REVISION: 1.0
DESCRIPTION: Using the OLED driver and IMU to present the pitch angle and rate of change using the filtered values from the accelerometer and gyroscope.
'''

import pyb
from pyb import LED, ADC, Pin
from oled_938 import OLED_938
from mpu6050 import MPU6050

# Create peripheral objects
b_led = LED(4)
imu = MPU6050(1, False)

# OLED initiation
oled = OLED_938(pinout={'sda': 'Y10', 'scl': 'Y9', 'res': 'Y8'}, height=64, external_vcc=False, i2c_devid=61)
oled.poweron()
oled.init_display()

# Reading from the IMU
def read_imu(dt):
    global g_pitch
    alpha = 0.7
    pitch = int(imu.pitch())
    g_pitch = alpha * (g_pitch + imu.get_gy()*dt*0.001) + (1-alpha)*pitch

    # display results
    oled.clear()
    oled.line(96,26,pitch,24,1)
    oled.line(32,26,g_pitch,24,1)
    oled.draw_text(0,0,"Raw | PITCH |")
    oled.draw_text(83,0,"filtered")
    oled.display()


g_pitch = 0
tic = pyb.millis()
while True:
    b_LED.toggle()
    toc = pyb.millis()
    read_imu(toc-tic)
    tic = pyb.millis()
