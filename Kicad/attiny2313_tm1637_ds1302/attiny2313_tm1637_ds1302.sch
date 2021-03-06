EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "Цифровые часы с будильником"
Date "2020-08-18"
Rev "1"
Comp ""
Comment1 ""
Comment2 "Вербкин М.С."
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L MCU_Microchip_ATtiny:ATtiny2313A-PU U1
U 1 1 5F394FAA
P 4950 4500
F 0 "U1" H 4950 4150 50  0000 C CNN
F 1 "ATtiny2313A-PU" H 4900 4450 50  0000 C CNN
F 2 "Package_DIP:DIP-20_W7.62mm" H 4950 4500 50  0001 C CIN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/doc8246.pdf" H 4950 4500 50  0001 C CNN
	1    4950 4500
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0101
U 1 1 5F3A5389
P 4950 5650
F 0 "#PWR0101" H 4950 5400 50  0001 C CNN
F 1 "GND" H 4955 5477 50  0000 C CNN
F 2 "" H 4950 5650 50  0001 C CNN
F 3 "" H 4950 5650 50  0001 C CNN
	1    4950 5650
	1    0    0    -1  
$EndComp
Wire Wire Line
	4950 5650 4950 5600
$Comp
L attiny2313_tm1637_ds1302-rescue:VCC-power #PWR0105
U 1 1 5F3A7F04
P 4950 3000
F 0 "#PWR0105" H 4950 2850 50  0001 C CNN
F 1 "VCC" H 4965 3173 50  0000 C CNN
F 2 "" H 4950 3000 50  0001 C CNN
F 3 "" H 4950 3000 50  0001 C CNN
	1    4950 3000
	1    0    0    -1  
$EndComp
$Comp
L Switch:SW_Push SW_1
U 1 1 5F3CFF50
P 7400 4750
F 0 "SW_1" H 7900 4750 50  0000 C CNN
F 1 "Mode" H 7900 4850 50  0000 C CNN
F 2 "Button_Switch_THT:SW_PUSH_6mm" H 7400 4950 50  0001 C CNN
F 3 "~" H 7400 4950 50  0001 C CNN
	1    7400 4750
	1    0    0    -1  
$EndComp
$Comp
L Switch:SW_Push SW_2
U 1 1 5F3D407E
P 7400 4850
F 0 "SW_2" H 7900 4750 50  0000 C CNN
F 1 "Clock_Set" H 7900 4850 50  0000 C CNN
F 2 "Button_Switch_THT:SW_PUSH_6mm" H 7400 5050 50  0001 C CNN
F 3 "~" H 7400 5050 50  0001 C CNN
	1    7400 4850
	1    0    0    -1  
$EndComp
$Comp
L Device:R R1
U 1 1 5F3E9815
P 4050 3550
F 0 "R1" H 4120 3596 50  0000 L CNN
F 1 "10kOm" H 4120 3505 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P5.08mm_Horizontal" V 3980 3550 50  0001 C CNN
F 3 "~" H 4050 3550 50  0001 C CNN
	1    4050 3550
	1    0    0    -1  
$EndComp
$Comp
L Device:R R2
U 1 1 5F3EB472
P 6000 3900
F 0 "R2" V 5793 3900 50  0000 C CNN
F 1 "10kOm" V 5884 3900 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0204_L3.6mm_D1.6mm_P5.08mm_Horizontal" V 5930 3900 50  0001 C CNN
F 3 "~" H 6000 3900 50  0001 C CNN
	1    6000 3900
	0    1    1    0   
$EndComp
Wire Wire Line
	5550 3900 5850 3900
$Comp
L Transistor_BJT:2N2219 Q1
U 1 1 5F3EE1BF
P 6450 3900
F 0 "Q1" H 6640 3946 50  0000 L CNN
F 1 "S9014" H 6640 3855 50  0000 L CNN
F 2 "Package_TO_SOT_THT:TO-92_Inline" H 6650 3825 50  0001 L CIN
F 3 "https://www.radiolibrary.ru/reference/transistor-imp/s9014c.html" H 6450 3900 50  0001 L CNN
	1    6450 3900
	1    0    0    -1  
$EndComp
Wire Wire Line
	6250 3900 6150 3900
Wire Wire Line
	4050 3700 4350 3700
$Comp
L Device:Buzzer BZ1
U 1 1 5F3F19A6
P 6650 3500
F 0 "BZ1" H 6802 3529 50  0000 L CNN
F 1 "Buzzer" H 6802 3438 50  0000 L CNN
F 2 "Buzzer_Beeper:Buzzer_12x9.5RM7.6" V 6625 3600 50  0001 C CNN
F 3 "~" V 6625 3600 50  0001 C CNN
	1    6650 3500
	1    0    0    -1  
$EndComp
Wire Wire Line
	6550 4100 7050 4100
Text GLabel 5650 4100 2    50   Input ~ 0
I\O
Text GLabel 5650 4000 2    50   Input ~ 0
SCLK
Wire Wire Line
	5550 4000 5650 4000
Text GLabel 5650 4200 2    50   Input ~ 0
RST
Wire Wire Line
	5650 4100 5550 4100
Wire Wire Line
	5550 4200 5650 4200
NoConn ~ 5550 4300
NoConn ~ 5550 4400
NoConn ~ 5550 4600
NoConn ~ 5550 4700
NoConn ~ 5550 5000
NoConn ~ 5550 5100
NoConn ~ 5550 5200
NoConn ~ 4350 3900
NoConn ~ 4350 4100
Wire Wire Line
	4050 3400 4950 3400
$Comp
L attiny2313_tm1637_ds1302-rescue:DS1302+-Timer_RTC U2
U 1 1 5F396480
P 4000 2550
F 0 "U2" H 4544 2596 50  0000 L CNN
F 1 "DS1302+" H 4544 2505 50  0000 L CNN
F 2 "Package_DIP:DIP-8_W7.62mm" H 4000 2050 50  0001 C CNN
F 3 "https://datasheets.maximintegrated.com/en/ds/DS1302.pdf" H 4000 2350 50  0001 C CNN
	1    4000 2550
	1    0    0    -1  
$EndComp
$Comp
L Device:Crystal Y1
U 1 1 5F3951E3
P 3000 2700
F 0 "Y1" V 3046 2569 50  0000 R CNN
F 1 "Crystal" V 2955 2569 50  0000 R CNN
F 2 "Crystal:Crystal_C26-LF_D2.1mm_L6.5mm_Horizontal" H 3000 2700 50  0001 C CNN
F 3 "~" H 3000 2700 50  0001 C CNN
	1    3000 2700
	0    -1   -1   0   
$EndComp
Wire Wire Line
	3000 2550 3500 2550
Wire Wire Line
	3500 2550 3500 2650
Wire Wire Line
	3500 2750 3500 2850
Wire Wire Line
	3500 2850 3000 2850
$Comp
L power:GND #PWR0103
U 1 1 5F3A691E
P 4000 3000
F 0 "#PWR0103" H 4000 2750 50  0001 C CNN
F 1 "GND" H 4005 2827 50  0000 C CNN
F 2 "" H 4000 3000 50  0001 C CNN
F 3 "" H 4000 3000 50  0001 C CNN
	1    4000 3000
	1    0    0    -1  
$EndComp
Wire Wire Line
	4000 3000 4000 2950
Text GLabel 3400 2350 0    50   Input ~ 0
SCLK
Wire Wire Line
	3500 2350 3400 2350
Text GLabel 3400 2450 0    50   Input ~ 0
RST
Wire Wire Line
	3500 2450 3400 2450
Text GLabel 4600 2350 2    50   Input ~ 0
I\O
Wire Wire Line
	4500 2350 4600 2350
NoConn ~ 4000 2150
Wire Wire Line
	6600 4750 6400 4750
$Comp
L Connector_Generic:Conn_01x02 J1
U 1 1 5F42D5C5
P 5850 2500
F 0 "J1" H 5930 2492 50  0000 L CNN
F 1 "Conn_01x02" H 5930 2401 50  0000 L CNN
F 2 "Battery:power_pins_smd" H 5850 2500 50  0001 C CNN
F 3 "~" H 5850 2500 50  0001 C CNN
	1    5850 2500
	1    0    0    -1  
$EndComp
Wire Wire Line
	5600 3800 5550 3800
Wire Wire Line
	4950 3400 4950 3200
Connection ~ 4950 3400
Wire Wire Line
	5550 3200 5250 3200
Connection ~ 4950 3200
Wire Wire Line
	4950 3200 4950 3000
$Comp
L power:GND #PWR0102
U 1 1 5F4475C4
P 5900 3350
F 0 "#PWR0102" H 5900 3100 50  0001 C CNN
F 1 "GND" V 5850 3250 50  0000 R CNN
F 2 "" H 5900 3350 50  0001 C CNN
F 3 "" H 5900 3350 50  0001 C CNN
	1    5900 3350
	0    1    1    0   
$EndComp
Connection ~ 5250 3200
Wire Wire Line
	5250 3200 5100 3200
$Comp
L Connector_Generic:Conn_01x04 J2
U 1 1 5F45461B
P 6800 4850
F 0 "J2" H 6750 5100 50  0000 L CNN
F 1 "Conn_01x04" H 6600 5200 50  0000 L CNN
F 2 "Connector:conn_01x04" H 6800 4850 50  0001 C CNN
F 3 "~" H 6800 4850 50  0001 C CNN
	1    6800 4850
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_01x04 J3
U 1 1 5F4552B2
P 7000 4850
F 0 "J3" H 7000 4500 50  0000 C CNN
F 1 "Conn_01x04" H 7000 4400 50  0000 C CNN
F 2 "Connector:conn_01x04" H 7000 4850 50  0001 C CNN
F 3 "~" H 7000 4850 50  0001 C CNN
	1    7000 4850
	-1   0    0    -1  
$EndComp
Wire Wire Line
	7600 4750 7600 4850
Connection ~ 7600 4850
Wire Wire Line
	7600 5050 7200 5050
Wire Wire Line
	5250 2900 6550 2900
Connection ~ 5250 2900
Wire Wire Line
	5250 2900 5250 3200
$Comp
L Device:R_POT RV1
U 1 1 5F40B1E0
P 7200 4100
F 0 "RV1" V 7085 4100 50  0000 C CNN
F 1 "R_POT" V 6994 4100 50  0000 C CNN
F 2 "Potentiometer_THT:Potentiometer_Bourns_3386P_Vertical" H 7200 4100 50  0001 C CNN
F 3 "~" H 7200 4100 50  0001 C CNN
	1    7200 4100
	0    -1   -1   0   
$EndComp
NoConn ~ 7350 4100
Wire Wire Line
	3900 2150 3900 2000
Wire Wire Line
	3900 2000 5100 2000
Wire Wire Line
	5100 2000 5100 3200
Connection ~ 5100 3200
Wire Wire Line
	5100 3200 4950 3200
$Comp
L Connector_Generic:Conn_01x04 J4
U 1 1 5F473773
P 6200 3250
F 0 "J4" H 6150 3500 50  0000 L CNN
F 1 "Conn_01x04" H 6300 3250 50  0000 L CNN
F 2 "Connector:conn_01x04" H 6200 3250 50  0001 C CNN
F 3 "~" H 6200 3250 50  0001 C CNN
	1    6200 3250
	1    0    0    -1  
$EndComp
Wire Wire Line
	5600 3150 5600 3800
Wire Wire Line
	6600 5050 6500 5050
Wire Wire Line
	6550 2900 6550 3400
Wire Wire Line
	6550 3600 6550 3700
Wire Wire Line
	6500 5100 6500 5050
$Comp
L power:GND #PWR0107
U 1 1 5F3E5318
P 6500 5100
F 0 "#PWR0107" H 6500 4850 50  0001 C CNN
F 1 "GND" V 6505 4972 50  0000 R CNN
F 2 "" H 6500 5100 50  0001 C CNN
F 3 "" H 6500 5100 50  0001 C CNN
	1    6500 5100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0104
U 1 1 5F4A7D64
P 7200 3850
F 0 "#PWR0104" H 7200 3600 50  0001 C CNN
F 1 "GND" H 7205 3677 50  0000 C CNN
F 2 "" H 7200 3850 50  0001 C CNN
F 3 "" H 7200 3850 50  0001 C CNN
	1    7200 3850
	-1   0    0    1   
$EndComp
Wire Wire Line
	7200 3950 7200 3850
Wire Wire Line
	5250 2500 5650 2500
Wire Wire Line
	5250 2500 5250 2900
$Comp
L power:GND #PWR0106
U 1 1 5F4B03F6
P 5550 2600
F 0 "#PWR0106" H 5550 2350 50  0001 C CNN
F 1 "GND" H 5555 2427 50  0000 C CNN
F 2 "" H 5550 2600 50  0001 C CNN
F 3 "" H 5550 2600 50  0001 C CNN
	1    5550 2600
	1    0    0    -1  
$EndComp
Wire Wire Line
	5650 2600 5550 2600
Wire Wire Line
	5550 3450 5550 3200
Wire Wire Line
	6000 3350 5900 3350
Wire Wire Line
	5550 3450 6000 3450
Wire Wire Line
	5650 3250 6000 3250
Wire Wire Line
	5600 3150 6000 3150
Wire Wire Line
	5550 3700 5650 3700
Wire Wire Line
	5650 3250 5650 3700
Wire Wire Line
	7600 4850 7600 5050
Wire Wire Line
	6600 4850 6600 4900
Wire Wire Line
	5550 4900 6600 4900
Wire Wire Line
	6400 4750 6400 4800
Wire Wire Line
	5550 4800 6400 4800
$EndSCHEMATC
