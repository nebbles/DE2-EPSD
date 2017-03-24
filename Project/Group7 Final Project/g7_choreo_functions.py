from motor import MOTOR

motor = MOTOR()

def readlist(filename):
    char_list = [ch for ch in open(filename).read() if ch not in ['\r', '\n']]
    return char_list

def readmove(moves, i, v):
    move = moves[i]
    if move == 'l':
        print('left 45')
        motor.A_forward(v)
        motor.B_forward(v/3)
    elif move == 'r':
        print('right 45')
        motor.A_forward(v/3)
        motor.B_forward(v)
    elif move == 'b':
        print('backwards')
        motor.A_back(v)
        motor.B_back(v)
    elif move == 'f':
        print('forwards')
        motor.A_forward(v)
        motor.B_forward(v)
    elif move == 'm':
        print('left 90')
        motor.A_forward(v/6)
        motor.B_forward(v)
    elif move == 'q':
        print('right 90')
        motor.A_forward(v)
        motor.B_forward(v/6)
    elif move == 'L':
        print('Left 45 backwards')
        motor.A_back(v)
        motor.B_back(v/3)
    elif move == 'R':
        print('right 45 backwards')
        motor.A_back(v/3)
        motor.B_back(v)
    elif move == 'o':
        print('centre pivot: both wheels same speed, one forwards one backwards')
        motor.A_back(v)
        motor.B_forward(v)
    elif move == 'O':
        print('centre pivot: both wheels same speed, one forwards one backwards, reversed')
        motor.B_back(v)
        motor.A_forward(v)
    elif move == 'p':
        print('Pivot: one wheel stationary, one forwards 15 degrees')
        motor.A_stop()
        motor.B_forward(v)
    elif move == 's':
        print('Stop')
        motor.A_stop()
        motor.B_stop()
    elif move == 'x':
        # if the previous move was also PC, do not send the signal again
        print('PC drawing')
    else:
        print('Potential error')
