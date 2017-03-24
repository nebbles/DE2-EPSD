import pyb
from pyb import Pin, Timer, ADC, UART
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
    print(pot_percentage)
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


# use keypad U and D keys to control speed

uart = UART(6) # Adafruit Bluefruit LE 3EDC
uart.init(9600, bits= 8, parity= None, stop= 2)

DEADZONE = 5
speed = 0

while True:
    while uart.any() != 10:
        pass
    command = uart.read(10)

    if command[2] == ord('5'):
        if speed < 96:
            speed += 5
            print(speed)

    elif command[2] == ord('6'):
        if speed > -96:
            speed -= 5
            print(speed)

    elif command[2] == ord('1'):
        speed = 0
        A_stop()
        B_stop()

    if speed >= DEADZONE:
        A_forward(speed)
        B_forward(speed)

    elif speed <= -DEADZONE:
        A_backward(abs(speed))
        B_backward(abs(speed))

    else:
        A_stop()
        B_stop()
