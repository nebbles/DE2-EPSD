import pyb
from pyb import LED, DAC, ADC, Pin
from oled_938 import OLED_938
from mpu6050 import MPU6050

# Define various ports, pins and peripherals
a_out = DAC(1, bits=12)
pot = ADC(Pin('X11'))
b_LED = LED(4)

# Use OLED to say what it is doing
oled = OLED_938(pinout={'sda': 'Y10', 'scl': 'Y9', 'res': 'Y8'}, height=64,
                   external_vcc=False, i2c_devid=61)
oled.poweron()
oled.init_display()
oled.draw_text(0, 0, 'Measure pitch and pitch_dot')
oled.draw_text(0,20, 'CCW: pitch (deg)')
oled.draw_text(0,30, 'CW: pitch_dot (deg/s)')
oled.display()

# IMU connected to X9 and X10
imu = MPU6050(1, False)

# Pitch angle calculation using complementary filter
def pitch_estimate(pitch, dt, alpha):
	theta = imu.pitch()
	pitch_dot = imu.get_gy()
	pitch = alpha*(pitch + pitch_dot*dt) + (1-alpha)*theta
	return (pitch, pitch_dot)
'''
Main program loop
'''
pitch = 0	# initialise pitch angle to 0 to start
alpha = 0.9	# alpha value in complementary filter
tic = pyb.millis()
while True:
	b_LED.toggle()
	dt = pyb.millis() - tic
	if dt > 20:		# sampling time is 20 msec or 50Hz
		[pitch, pitch_dot] = pitch_estimate(pitch, dt*0.001, alpha)
		tic = pyb.millis()
		if pot.read() > 2048:	# decide which to send to X5 (BNC)
			a_out.write(min(4095,int(pitch*40)+2048))
		else:
			a_out.write(min(4095,int(pitch_dot*10)+2048))
