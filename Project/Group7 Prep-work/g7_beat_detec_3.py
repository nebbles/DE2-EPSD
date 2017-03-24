'''    Start of comment section
-------------------------------------------------------
Name: Basic Beat Detection implementation
Creator:  Peter YK Cheung
Date:   14 March 2017
Revision:  1.3
-------------------------------------------------------
This program do the following:
1. Use interrupt to collect samples from mic at 8kHz rate.
2. Compute instantenous energy E for 20msec window
3. Obtain sum of previous 50 instanteneous energy measurements
	as sum_energy, equivalent to 1 sec worth of signal.
4. Find the ratio c = instantenous energy/(sum_energy/50)
5. Wait for elapsed time > (beat_period - some margin)
	since last detected beat
6. Check c value and if higher than BEAT_THRESHOLD,
	flash blue LED
'''
print('running')
