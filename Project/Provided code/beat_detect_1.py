'''    Start of comment section
-------------------------------------------------------
Name: Basic Beat Detection implementation using microphone class
Creator:  Peter YK Cheung
Date:   16 March 2017
Revision:  1.5
-------------------------------------------------------
'''    
import pyb
from pyb import Pin, Timer, ADC, DAC, LED
from array import array			# need this for memory allocation to buffers
from oled_938 import OLED_938	# Use OLED display driver
from mic import MICROPHONE

#  The following two lines are needed by micropython 
#   ... must include if you use interrupt in your program
import micropython
micropython.alloc_emergency_exception_buf(100)

print('beat_detect_1.py')

# I2C connected to Y9, Y10 (I2C bus 2) and Y11 is reset low active
oled = OLED_938(pinout={'sda': 'Y10', 'scl': 'Y9', 'res': 'Y8'}, height=64,
                   external_vcc=False, i2c_devid=61)  
oled.poweron()
oled.init_display()
oled.draw_text(0,0, 'Basic Beat Detection')
oled.display()

# Create microphone object
SAMP_FREQ = 8000
N = 160
mic = MICROPHONE(Timer(7,freq=SAMP_FREQ),ADC('Y11'),N)

# define ports for microphone, LEDs and trigger out (X5)
b_LED = LED(4)		# flash for beats on blue LED

# Define constants for main program loop - shown in UPPERCASE
M = 50						# number of instantaneous energy epochs to sum
BEAT_THRESHOLD = 2.0		# threshold for c to indicate a beat

# initialise variables for main program loop 
e_ptr = 0					# pointer to energy buffer
e_buf = array('L', 0 for i in range(M))	# reserve storage for energy buffer
sum_energy = 0				# total energy in last 50 epochs
pyb.delay(100)
tic = pyb.millis()			# mark time now in msec

# real-time program loop
while True:				# Main program loop
	if mic.buffer_full():		# semaphore signal from ISR - set if buffer is full
		b_LED.off()				# flash off
		# Get instantaneous energy
		E = mic.inst_energy()
		
		# compute moving sum of last 50 energy epochs
		sum_energy = sum_energy - e_buf[e_ptr] + E
		e_buf[e_ptr] = E		# over-write earlest energy with most recent
		e_ptr = (e_ptr + 1) % M	# increment e_ptr with wraparound - 0 to M-1
		
		# Compute ratio of instantaneous energy/average energy
		c = E*M/sum_energy
		# Look for a beat		
		if (pyb.millis()-tic > 400):	# if more than 400ms since last beat
			if (c>BEAT_THRESHOLD):		# look for a beat
				tic = pyb.millis()		# reset tic
				b_LED.on()				# beat found, flash blue LED ON
		mic.set_buffer_empty()			# reset the buffer_full flag
		
		