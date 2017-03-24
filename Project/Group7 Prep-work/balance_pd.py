import pyb, time
from pyb import LED, DAC, ADC, Pin
from oled_938 import OLED_938
from mpu6050 import MPU6050
from motor import MOTOR

# Define various ports, pins and peripherals
a_out = DAC(1, bits=12)
pot = ADC(Pin('X11'))
b_LED = LED(4)

# Use OLED to say what it is doing
oled = OLED_938(pinout={'sda': 'Y10', 'scl': 'Y9', 'res': 'Y8'}, height=64,
                   external_vcc=False, i2c_devid=61)
oled.poweron()
oled.init_display()
oled.draw_text(0, 0, 'Group 7')
oled.draw_text(0,10, 'Self-balance v1')
oled.draw_text(0,20, 'Press USR button')
oled.display()

# use pot to set Kp


print('balance.py')
print('Waiting for button press.')
sw = pyb.Switch()
while not sw():
	time.sleep(0.001)

	K_p = pot.read() * 12.0 / 4095
	oled.draw_text(0, 30, 'Kp = {:5.2f}'.format(K_p))
	oled.display()


print('Button pressed. Running script.')
oled.draw_text(0, 20, 'Button pressed. Running.')
oled.display()

# IMU connected to X9 and X10
imu = MPU6050(1, False)

# Pitch angle calculation using complementary filter
def pitch_estimate(pitch, dt, alpha):
	theta = imu.pitch()
	pitch_dot = imu.get_gy()
	pitch = alpha*(pitch + pitch_dot*dt) + (1-alpha)*theta
	return (pitch, pitch_dot)

motor = MOTOR()

'''
Main program loop
'''
pitch = 0	# initialise pitch angle to 0 to start
alpha = 0.965	# alpha value in complementary filter

error_current = 0
error_last = 0
# K_p = 5.0
K_d = 0.23 # 0.23 - .29
# K_i = 0.1
pitch_target = -1.5 # lean towards top of board
offset = 5

oled.draw_text(0, 40, 'Kd = {:5.2f}'.format(K_d))
oled.draw_text(0, 50, 'Target = {:5.2f}'.format(pitch_target))
oled.display()

try:
	tic = pyb.micros()
	while True:
		b_LED.toggle()
		dt = pyb.micros() - tic
		if dt > 5000:		# sampling time is 5 msec or 50Hz
			pitch, pitch_dot = pitch_estimate(pitch, dt*0.000001, alpha)
			tic = pyb.micros()

			pitch_error = pitch - pitch_target
			u = K_p * pitch_error + K_d * pitch_dot

			if u > 100: u = 100 # limit u to + - 100
			elif u < -100: u = -100


			if u > 0:
				motor.A_forward(abs(u)+offset)
				motor.B_forward(abs(u)+offset)
			elif u < 0:
				motor.A_back(abs(u)+offset)
				motor.B_back(abs(u)+offset)
			else:
				motor.A_stop()
				motor.B_stop()

finally:
	motor.A_stop()
	motor.B_stop()