'''
-------------------------------------------------------
Name: Group 7 Self-Balancing Algorithm with LED Beat Detection
Creator: Benedict Greenberg
Date: 23 March 2017
Revision: 1.0
-------------------------------------------------------
Same as g7_balance.py with LED beat detection added.
-------------------------------------------------------
'''
import pyb, time
from pyb import LED, DAC, ADC, Pin, Timer
from oled_938 import OLED_938
from mpu6050 import MPU6050
from motor import MOTOR
from g7_pid_controller import PIDC
from array import array			# need this for memory allocation to buffers
from mic import MICROPHONE
import micropython
micropython.alloc_emergency_exception_buf(100)


# Define various ports, pins and peripherals
a_out = DAC(1, bits=12)
pot = ADC(Pin('X11'))
b_LED = LED(4)

# IMU connected to X9 and X10
imu = MPU6050(1, False)

# Use OLED to say what it is doing
oled = OLED_938(pinout={'sda': 'Y10', 'scl': 'Y9', 'res': 'Y8'}, height=64, external_vcc=False, i2c_devid=61)
oled.poweron()
oled.init_display()
oled.draw_text(0, 0, 'Group 7')
oled.draw_text(0,10, 'Balance & Beat')
oled.draw_text(0,20, 'Press USR button')
oled.display()


print('g7_balance_beat.py')
print('Waiting for button press.')
sw = pyb.Switch()

while not sw(): # prevent program from running until user is ready and has chosen value on POT
	time.sleep(0.001)
	K_p = pot.read() * 8.0 / 4095 # use pot to set Kp
	K_p = 5.41 # this is a manual override added once a suitable K_p was found
	oled.draw_text(0, 30, 'Kp = {:5.2f}'.format(K_p)) # display live value on oled
	oled.display()
while sw(): pass # wait for button release
while not sw(): # prevent program from running until user is ready and has chosen value on POT
	time.sleep(0.001)
	K_i = pot.read() * 2.0 / 4095 # use pot to set Ki
	K_i = 0.22 # this is a manual override added once a suitable K_p was found
	oled.draw_text(0, 40, 'Ki = {:5.2f}'.format(K_i)) # display live value on oled
	oled.display()
while sw(): pass # wait for button release
while not sw(): # prevent program from running until user is ready and has chosen value on POT
	time.sleep(0.001)
	K_d = pot.read() * 2.0 / 4095 # use pot to set Kd
	K_d = 0.33 # this is a manual override added once a suitable K_p was found
	oled.draw_text(0, 50, 'Kd = {:5.2f}'.format(K_d)) # display live value on oled
	oled.display()
while sw(): pass # wait for button release

print('Button pressed. Running script.')
oled.draw_text(0, 20, 'Button pressed. Running.')
oled.display()


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
alpha = 0.95	# alpha value in complementary filter

calibration = -1.2 # calibrate for centre of mass (negative: lean towards top of board)
motor_offset = 5 # remove motor deadzone

motor = MOTOR() # init motor object
pidc = PIDC(Kp=K_p, Kd=K_d, Ki=K_i, theta_0=calibration) # init PID controller object
pidc.target_reset() # set target point for self-balance as normal to ground


# Create microphone object
# define ports for microphone, LEDs and trigger out (X5)
SAMP_FREQ = 8000
N = 160
mic = MICROPHONE(Timer(7,freq=SAMP_FREQ),ADC('Y11'),N)

# Define constants for main program loop - shown in UPPERCASE
M = 50						# number of instantaneous energy epochs to sum
BEAT_THRESHOLD = 1.9		# threshold for c to indicate a beat

# initialise variables for main program loop
e_ptr = 0					# pointer to energy buffer
e_buf = array('L', 0 for i in range(M))	# reserve storage for energy buffer
sum_energy = 0				# total energy in last 50 epochs
pyb.delay(100)
tic2 = pyb.millis()			# mark time now in msec



try:
	tic = pyb.micros()
	while True:
		dt = pyb.micros() - tic
		if dt > 5000:		# sampling time is 5 msec or 50Hz
			pitch, pitch_dot = pitch_estimate(pitch, dt*0.000001, alpha)
			tic = pyb.micros()

			u = pidc.get_pwm(pitch, pitch_dot)

			if u > 0:
				motor.A_forward(abs(u)+motor_offset)
				motor.B_forward(abs(u)+motor_offset)
			elif u < 0:
				motor.A_back(abs(u)+motor_offset)
				motor.B_back(abs(u)+motor_offset)
			else:
				motor.A_stop()
				motor.B_stop()

		if mic.buffer_full():  # semaphore signal from ISR - set if buffer is full
			b_LED.off()  # flash off
			# Get instantaneous energy
			E = mic.inst_energy()

			# compute moving sum of last 50 energy epochs
			sum_energy = sum_energy - e_buf[e_ptr] + E
			e_buf[e_ptr] = E  # over-write earlest energy with most recent
			e_ptr = (e_ptr + 1) % M  # increment e_ptr with wraparound - 0 to M-1

			# Compute ratio of instantaneous energy/average energy
			c = E * M / sum_energy
			# Look for a beat
			if (pyb.millis() - tic2 > 500):  # if more than 400ms since last beat
				if (c > BEAT_THRESHOLD) or (pyb.millis()-tic > 600):  # look for a beat
					tic2 = pyb.millis()  # reset tic
					b_LED.on()  # beat found, flash blue LED ON
			mic.set_buffer_empty()  # reset the buffer_full flag

finally: # in the event of a crash or keyboard interrupt turn of motors before exiting program
	motor.A_stop()
	motor.B_stop()