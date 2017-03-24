'''
-------------------------------------------------------
Name: Group 7 Basic Bluetooth Drive Control
Creator: Felix Crowther
Date: 23 March 2017
Revision: 1.0
-------------------------------------------------------
Basic bluetooth control for the segway robot (no balancing).
-------------------------------------------------------
'''
# Drive controls

# Initialise with variables first
# Define the pins to control the motor
A1 = Pin('X3', Pin.OUT_PP)
A2 = Pin('X4', Pin.OUT_PP)
PWMA_A = Pin('X1')

B1 = Pin('X8', Pin.OUT_PP)
B2 = Pin('X7', Pin.OUT_PP)
PWMA_B = Pin('X2')

# Configure timer 2 to produce 1kHz clock for PWM control
tim = Timer(2, freq = 1000)
motorA = tim.channel (1, Timer.PWM, pin = PWMA_A)
motorB = tim.channel (2, Timer.PWM, pin = PWMA_B)

def A_forward(value):
  A1.low()
  A2.high()
  motorA.pulse_width_percent(value)

def B_forward(value):
  B1.low()
  B2.high()
  motorB.pulse_width_percent(value)

def A_backward(value):
  A1.high()
  A2.low()
  motorA.pulse_width_percent(value)

def B_backward(value):
  B1.high()
  B2.low()
  motorB.pulse_width_percent(value)

def A_stop():
    A1.low()
    A2.low()
    motorA.pulse_width_percent(0)

def B_stop():
    B1.low()
    B2.low()
    motorB.pulse_width_percent(0)
