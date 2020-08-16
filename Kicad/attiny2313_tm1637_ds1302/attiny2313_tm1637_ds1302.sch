EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L MCU_Microchip_ATtiny:ATtiny2313A-PU U?
U 1 1 5F394FAA
P 2750 2550
F 0 "U?" H 2750 3831 50  0000 C CNN
F 1 "ATtiny2313A-PU" H 2750 3740 50  0000 C CNN
F 2 "Package_DIP:DIP-20_W7.62mm" H 2750 2550 50  0001 C CIN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/doc8246.pdf" H 2750 2550 50  0001 C CNN
	1    2750 2550
	1    0    0    -1  
$EndComp
$Comp
L Timer_RTC:DS1302+ U?
U 1 1 5F396480
P 5950 4550
F 0 "U?" H 6494 4596 50  0000 L CNN
F 1 "DS1302+" H 6494 4505 50  0000 L CNN
F 2 "Package_DIP:DIP-8_W7.62mm" H 5950 4050 50  0001 C CNN
F 3 "https://datasheets.maximintegrated.com/en/ds/DS1302.pdf" H 5950 4350 50  0001 C CNN
	1    5950 4550
	1    0    0    -1  
$EndComp
$Comp
L Display_Graphic:tm1637-module U?
U 1 1 5F3989A8
P 2850 4600
F 0 "U?" H 2825 4965 50  0000 C CNN
F 1 "tm1637-module" H 2825 4874 50  0000 C CNN
F 2 "" H 2700 4250 50  0001 C CNN
F 3 "http://arduino.on.kg/show/221" H 2700 4250 50  0001 C CNN
	1    2850 4600
	1    0    0    -1  
$EndComp
$Comp
L Device:Crystal Y?
U 1 1 5F3951E3
P 4950 4700
F 0 "Y?" V 4996 4569 50  0000 R CNN
F 1 "Crystal" V 4905 4569 50  0000 R CNN
F 2 "" H 4950 4700 50  0001 C CNN
F 3 "~" H 4950 4700 50  0001 C CNN
	1    4950 4700
	0    -1   -1   0   
$EndComp
Wire Wire Line
	4950 4550 5450 4550
Wire Wire Line
	5450 4550 5450 4650
Wire Wire Line
	5450 4750 5450 4850
Wire Wire Line
	5450 4850 4950 4850
$EndSCHEMATC
