import pyb
from pyb import Pin, Timer, ADC
import time
from oled_938 import OLED_938

# Define pins to control motor
A1 = Pin('X3', Pin.OUT_PP)
A2 = Pin('X4', Pin.OUT_PP)
PWMA = Pin('X1')

B1 = Pin('X7', Pin.OUT_PP)
B2 = Pin('X8', Pin.OUT_PP)
PWMB = Pin('X2')

# Confifure timer 2 to produce 1kHz clock for PWM control
tim = Timer(2, freq=1000)
motorA = tim.channel(1,Timer.PWM, pin = PWMA)
motorB = tim.channel(2,Timer.PWM, pin = PWMB)

# Define pins for motor encoders
A_sense = Pin('Y4', Pin.PULL_NONE)
B_sense = Pin('Y6', Pin.PULL_NONE)

# Define the potentiometer
pot = pyb.ADC(Pin('X11'))

oled = OLED_938(pinout={'sda':'Y10','scl':'Y9','res':'Y8'}, height = 64, external_vcc=False, i2c_devid=61)
oled.poweron()
oled.init_display()
oled.draw_text(0,0,'Clarisse')
oled.display()

def get_pot_percent(): # 0 -> 4095
    pot_value = pot.read()
    pot_percentage = (pot_value/4095.0)*100
    return pot_percentage

def A_forward(value):
    A1.low()
    A2.high()
    motorA.pulse_width_percent(value)

def A_backward(value):
    A1.high()
    A2.low()
    motorA.pulse_width_percent(value)

def A_stop():
    A1.low()
    A2.low()

def B_backward(value):
    B1.low()
    B2.high()
    motorB.pulse_width_percent(value)

def B_forward(value):
    B1.high()
    B2.low()
    motorB.pulse_width_percent(value)

def B_stop():
    B1.low()
    B2.low()

A_state = 0 # previous state of A sensor
A_speed = 0 # latest speed of A motorA
A_count = 0 # positve transition count

B_state = 0 # previous state of A sensor
B_speed = 0 # latest speed of A motorA
B_count = 0 # positve transition count

tic = pyb.millis() # timer

try:
    while True:

        if A_state == 0 and A_sense.value() == 1:
            # edge was detected
            A_count += 1
        if B_state == 0 and B_sense.value() == 1:
            # edge was detected
            B_count += 1

        A_state = A_sense.value()
        B_state = B_sense.value()

        # Check to see if 100 msec elapsed
        toc = pyb.millis()
        if (toc-tic) >= 100:
            A_speed = A_count/39
            B_speed = B_count/39
            A_count = 0
            B_count = 0

            pot_percent = get_pot_percent()
            A_forward(int(pot_percent))
            B_forward(int(pot_percent))

            print('POT: ',int(pot_percent),'Speed A: ',A_speed,'Speed B: ',B_speed)
            oled.draw_text(0,30,'Potentiometer:{:5d}%'.format(int(pot_percent)))
            oled.draw_text(0,40,'Speed A:{:5.2f} rps'.format(A_speed) )
            oled.draw_text(0,50,'Speed B:{:5.2f} rps'.format(B_speed) )
            oled.display()

            tic = pyb.millis()

finally:
    A_stop()
    B_stop()
