## DE2 Electronics Project - Self-balancing Dancing to Music Two-Wheeled Robot

Group 7  
> Anna Bernbaum  
> Clarisse Bret  
> Felix Crowther  
> Benedict Greenberg

### Videos and Pictures

[External link to files](http://bit.ly/DE2-EPSD-G7-MEDIA)

### Calibration

Calibration of PID resulted in the following parameters for PyBench-09

Parameter | Value
--- | ---:
Vertical offset calibration | -1.2
Kp | 5.41
Ki | 0.22
Kd | 0.33

### Code 

File name | *Description*
--- | ---
g7_balance_beat.py | **(Switch setting: 00)** Program will self-balance robot and detect beat using blue LED as output. This is the main self-balancing program.
g7_balance_bluetooth.py | **(Switch setting: 10)** Example program of how Bluetooth can be implemented whilst balancing. Beat detection also occurring here. Program works although can cause the robot to fall if there is too much interference from user.
g7_balance_dance.py | **(Switch setting: 01)** Program demonstrating balancing robot reacting to beat detection with attempted dance moves.
g7_balance.py | Program used to tune K values for PID control.
g7_choreo_functions.py | Program used to translate commands from txt file to motor instructions.
g7_choreo.txt | First choreography produced from MATLAB analysis.
g7_choreo2.txt | Second choreography produced from MATLAB analysis.
g7_dance.py | **(Switch setting: 11)** Program that runs routine based on beat detection. This runs without balancing robot due to complex and rapid moves.
g7_drive.py | Simple example of Bluetooth control of robot before balancing or dancing.
g7_pid_controller.py | Class which runs PID control on Segway for balancing.
main.py | Modified main script to utilise the binary switch on PyBench.
