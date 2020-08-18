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
P 3600 3650
F 0 "U1" H 3600 3300 50  0000 C CNN
F 1 "ATtiny2313A-PU" H 3550 3600 50  0000 C CNN
F 2 "Package_DIP:DIP-20_W7.62mm" H 3600 3650 50  0001 C CIN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/doc8246.pdf" H 3600 3650 50  0001 C CNN
	1    3600 3650
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0101
U 1 1 5F3A5389
P 3600 4800
F 0 "#PWR0101" H 3600 4550 50  0001 C CNN
F 1 "GND" H 3605 4627 50  0000 C CNN
F 2 "" H 3600 4800 50  0001 C CNN
F 3 "" H 3600 4800 50  0001 C CNN
	1    3600 4800
	1    0    0    -1  
$EndComp
Wire Wire Line
	3600 4800 3600 4750
$Comp
L power:VCC #PWR0105
U 1 1 5F3A7F04
P 3600 2150
F 0 "#PWR0105" H 3600 2000 50  0001 C CNN
F 1 "VCC" H 3615 2323 50  0000 C CNN
F 2 "" H 3600 2150 50  0001 C CNN
F 3 "" H 3600 2150 50  0001 C CNN
	1    3600 2150
	1    0    0    -1  
$EndComp
$Comp
L Switch:SW_Push SW_1
U 1 1 5F3CFF50
P 6050 3900
F 0 "SW_1" H 6550 3900 50  0000 C CNN
F 1 "Mode" H 6550 4000 50  0000 C CNN
F 2 "Button_Switch_THT:SW_PUSH_6mm" H 6050 4100 50  0001 C CNN
F 3 "~" H 6050 4100 50  0001 C CNN
	1    6050 3900
	1    0    0    -1  
$EndComp
$Comp
L Switch:SW_Push SW_3
U 1 1 5F3D407E
P 6050 4000
F 0 "SW_3" H 6550 3900 50  0000 C CNN
F 1 "Brightness" H 6550 4000 50  0000 C CNN
F 2 "Button_Switch_THT:SW_PUSH_6mm" H 6050 4200 50  0001 C CNN
F 3 "~" H 6050 4200 50  0001 C CNN
	1    6050 4000
	1    0    0    -1  
$EndComp
$Comp
L Simulation_SPICE:DIODE D1
U 1 1 5F3DD583
P 4650 3850
F 0 "D1" V 4604 3930 50  0000 L CNN
F 1 "DIODE" V 4695 3930 50  0000 L CNN
F 2 "Diode_THT:D_DO-15_P3.81mm_Vertical_KathodeUp" H 4650 3850 50  0001 C CNN
F 3 "~" H 4650 3850 50  0001 C CNN
F 4 "Y" H 4650 3850 50  0001 L CNN "Spice_Netlist_Enabled"
F 5 "D" H 4650 3850 50  0001 L CNN "Spice_Primitive"
	1    4650 3850
	0    1    1    0   
$EndComp
$Comp
L Simulation_SPICE:DIODE D2
U 1 1 5F3DE4C2
P 4650 4250
F 0 "D2" V 4696 4170 50  0000 R CNN
F 1 "DIODE" V 4605 4170 50  0000 R CNN
F 2 "Diode_THT:D_DO-15_P3.81mm_Vertical_KathodeUp" H 4650 4250 50  0001 C CNN
F 3 "~" H 4650 4250 50  0001 C CNN
F 4 "Y" H 4650 4250 50  0001 L CNN "Spice_Netlist_Enabled"
F 5 "D" H 4650 4250 50  0001 L CNN "Spice_Primitive"
	1    4650 4250
	0    -1   -1   0   
$EndComp
Wire Wire Line
	4650 3700 4500 3700
Wire Wire Line
	4500 3700 4500 3950
Wire Wire Line
	4500 3950 4200 3950
Wire Wire Line
	4650 4400 4500 4400
Wire Wire Line
	4500 4400 4500 4050
Wire Wire Line
	4500 4050 4200 4050
$Comp
L Device:R R1
U 1 1 5F3E9815
P 2700 2700
F 0 "R1" H 2770 2746 50  0000 L CNN
F 1 "10kOm" H 2770 2655 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0309_L9.0mm_D3.2mm_P5.08mm_Vertical" V 2630 2700 50  0001 C CNN
F 3 "~" H 2700 2700 50  0001 C CNN
	1    2700 2700
	1    0    0    -1  
$EndComp
$Comp
L Device:R R2
U 1 1 5F3EB472
P 4650 3050
F 0 "R2" V 4443 3050 50  0000 C CNN
F 1 "10kOm" V 4534 3050 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0309_L9.0mm_D3.2mm_P5.08mm_Vertical" V 4580 3050 50  0001 C CNN
F 3 "~" H 4650 3050 50  0001 C CNN
	1    4650 3050
	0    1    1    0   
$EndComp
Wire Wire Line
	4200 3050 4500 3050
$Comp
L Transistor_BJT:2N2219 Q1
U 1 1 5F3EE1BF
P 5100 3050
F 0 "Q1" H 5290 3096 50  0000 L CNN
F 1 "S9014" H 5290 3005 50  0000 L CNN
F 2 "Package_TO_SOT_THT:SIPAK_Vertical" H 5300 2975 50  0001 L CIN
F 3 "https://www.radiolibrary.ru/reference/transistor-imp/s9014c.html" H 5100 3050 50  0001 L CNN
	1    5100 3050
	1    0    0    -1  
$EndComp
Wire Wire Line
	4900 3050 4800 3050
Wire Wire Line
	2700 2850 3000 2850
$Comp
L Device:Buzzer BZ1
U 1 1 5F3F19A6
P 5300 2650
F 0 "BZ1" H 5452 2679 50  0000 L CNN
F 1 "Buzzer" H 5452 2588 50  0000 L CNN
F 2 "Buzzer_Beeper:Buzzer_12x9.5RM7.6" V 5275 2750 50  0001 C CNN
F 3 "~" V 5275 2750 50  0001 C CNN
	1    5300 2650
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR0108
U 1 1 5F3F2739
P 5200 1950
F 0 "#PWR0108" H 5200 1800 50  0001 C CNN
F 1 "VCC" H 5215 2123 50  0000 C CNN
F 2 "" H 5200 1950 50  0001 C CNN
F 3 "" H 5200 1950 50  0001 C CNN
	1    5200 1950
	1    0    0    -1  
$EndComp
Wire Wire Line
	5200 2750 5200 2850
$Comp
L Device:R_Variable R3
U 1 1 5F3F6D79
P 5850 3250
F 0 "R3" V 5605 3250 50  0000 C CNN
F 1 "R_Variable" V 5696 3250 50  0000 C CNN
F 2 "Potentiometer_THT:Potentiometer_Vishay_T73YP_Vertical" V 5780 3250 50  0001 C CNN
F 3 "~" H 5850 3250 50  0001 C CNN
	1    5850 3250
	0    1    1    0   
$EndComp
Wire Wire Line
	5200 3250 5700 3250
Text GLabel 4300 3250 2    50   Input ~ 0
SCLK
Text GLabel 4300 3150 2    50   Input ~ 0
RST
Wire Wire Line
	4200 3150 4300 3150
Text GLabel 4300 3350 2    50   Input ~ 0
I\O
Wire Wire Line
	4300 3250 4200 3250
Wire Wire Line
	4200 3350 4300 3350
NoConn ~ 4200 3450
NoConn ~ 4200 3550
NoConn ~ 4200 3750
NoConn ~ 4200 3850
NoConn ~ 4200 4150
NoConn ~ 4200 4250
NoConn ~ 4200 4350
NoConn ~ 3000 3050
NoConn ~ 3000 3250
Wire Wire Line
	6000 3250 6150 3250
$Comp
L power:GND #PWR0109
U 1 1 5F3F866A
P 6150 3250
F 0 "#PWR0109" H 6150 3000 50  0001 C CNN
F 1 "GND" H 6155 3077 50  0000 C CNN
F 2 "" H 6150 3250 50  0001 C CNN
F 3 "" H 6150 3250 50  0001 C CNN
	1    6150 3250
	1    0    0    -1  
$EndComp
Wire Wire Line
	2700 2550 3600 2550
$Comp
L Timer_RTC:DS1302+ U2
U 1 1 5F396480
P 8150 4100
F 0 "U2" H 8694 4146 50  0000 L CNN
F 1 "DS1302+" H 8694 4055 50  0000 L CNN
F 2 "Package_DIP:DIP-8_W7.62mm" H 8150 3600 50  0001 C CNN
F 3 "https://datasheets.maximintegrated.com/en/ds/DS1302.pdf" H 8150 3900 50  0001 C CNN
	1    8150 4100
	1    0    0    -1  
$EndComp
$Comp
L Device:Crystal Y1
U 1 1 5F3951E3
P 7150 4250
F 0 "Y1" V 7196 4119 50  0000 R CNN
F 1 "Crystal" V 7105 4119 50  0000 R CNN
F 2 "Crystal:Crystal_AT310_D3.0mm_L10.0mm_Vertical" H 7150 4250 50  0001 C CNN
F 3 "~" H 7150 4250 50  0001 C CNN
	1    7150 4250
	0    -1   -1   0   
$EndComp
Wire Wire Line
	7150 4100 7650 4100
Wire Wire Line
	7650 4100 7650 4200
Wire Wire Line
	7650 4300 7650 4400
Wire Wire Line
	7650 4400 7150 4400
$Comp
L power:GND #PWR0103
U 1 1 5F3A691E
P 8150 4550
F 0 "#PWR0103" H 8150 4300 50  0001 C CNN
F 1 "GND" H 8155 4377 50  0000 C CNN
F 2 "" H 8150 4550 50  0001 C CNN
F 3 "" H 8150 4550 50  0001 C CNN
	1    8150 4550
	1    0    0    -1  
$EndComp
Wire Wire Line
	8150 4550 8150 4500
Text GLabel 7550 3900 0    50   Input ~ 0
SCLK
Wire Wire Line
	7650 3900 7550 3900
Text GLabel 7550 4000 0    50   Input ~ 0
RST
Wire Wire Line
	7650 4000 7550 4000
Text GLabel 8750 3900 2    50   Input ~ 0
I\O
Wire Wire Line
	8650 3900 8750 3900
$Comp
L power:VCC #PWR0106
U 1 1 5F3D6B4C
P 8050 3600
F 0 "#PWR0106" H 8050 3450 50  0001 C CNN
F 1 "VCC" H 8065 3773 50  0000 C CNN
F 2 "" H 8050 3600 50  0001 C CNN
F 3 "" H 8050 3600 50  0001 C CNN
	1    8050 3600
	1    0    0    -1  
$EndComp
Wire Wire Line
	8050 3600 8050 3700
NoConn ~ 8150 3700
Wire Wire Line
	4650 4000 4650 4050
Wire Wire Line
	5250 3900 5050 3900
Wire Wire Line
	5050 3900 5050 3700
Wire Wire Line
	5050 3700 4650 3700
Connection ~ 4650 3700
Wire Wire Line
	5050 4400 4650 4400
Connection ~ 4650 4400
Wire Wire Line
	5250 4000 4700 4000
Wire Wire Line
	4700 4000 4700 4050
Wire Wire Line
	4700 4050 4650 4050
Connection ~ 4650 4050
Wire Wire Line
	4650 4050 4650 4100
Wire Wire Line
	5250 4200 5150 4200
$Comp
L Switch:SW_Push SW_2
U 1 1 5F3D2606
P 6050 4100
F 0 "SW_2" H 6550 3900 50  0000 C CNN
F 1 "Clock_mode" H 6550 4000 50  0000 C CNN
F 2 "Button_Switch_THT:SW_PUSH_6mm" H 6050 4300 50  0001 C CNN
F 3 "~" H 6050 4300 50  0001 C CNN
	1    6050 4100
	1    0    0    -1  
$EndComp
Wire Wire Line
	5050 4400 5050 4100
Wire Wire Line
	5050 4100 5250 4100
Wire Wire Line
	5150 4250 5150 4200
$Comp
L power:GND #PWR0107
U 1 1 5F3E5318
P 5150 4250
F 0 "#PWR0107" H 5150 4000 50  0001 C CNN
F 1 "GND" V 5155 4122 50  0000 R CNN
F 2 "" H 5150 4250 50  0001 C CNN
F 3 "" H 5150 4250 50  0001 C CNN
	1    5150 4250
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_01x02 J1
U 1 1 5F42D5C5
P 4200 1850
F 0 "J1" H 4280 1842 50  0000 L CNN
F 1 "Conn_01x02" H 4280 1751 50  0000 L CNN
F 2 "Battery:power_pins_smd" H 4200 1850 50  0001 C CNN
F 3 "~" H 4200 1850 50  0001 C CNN
	1    4200 1850
	1    0    0    -1  
$EndComp
$Comp
L attiny2313_tm1637_ds1302-rescue:tm1637-module-Display_Graphic-attiny2313_tm1637_ds1302-rescue U3
U 1 1 5F3989A8
P 4550 2450
F 0 "U3" H 4525 2815 50  0000 C CNN
F 1 "tm1637-module" H 4525 2724 50  0000 C CNN
F 2 "Module:tm1637-module" H 4400 2100 50  0001 C CNN
F 3 "http://arduino.on.kg/show/221" H 4400 2100 50  0001 C CNN
	1    4550 2450
	1    0    0    -1  
$EndComp
Wire Wire Line
	4850 2550 4850 2700
Wire Wire Line
	4850 2700 4200 2700
Wire Wire Line
	4200 2700 4200 2850
Wire Wire Line
	4850 2350 4900 2350
Wire Wire Line
	4900 2350 4900 2750
Wire Wire Line
	4900 2750 4250 2750
Wire Wire Line
	4250 2750 4250 2950
Wire Wire Line
	4250 2950 4200 2950
Wire Wire Line
	3600 2550 3600 2350
Connection ~ 3600 2550
Wire Wire Line
	4200 2350 3900 2350
Connection ~ 3600 2350
Wire Wire Line
	3600 2350 3600 2150
$Comp
L power:GND #PWR0102
U 1 1 5F4475C4
P 4100 2550
F 0 "#PWR0102" H 4100 2300 50  0001 C CNN
F 1 "GND" V 4105 2422 50  0000 R CNN
F 2 "" H 4100 2550 50  0001 C CNN
F 3 "" H 4100 2550 50  0001 C CNN
	1    4100 2550
	0    1    1    0   
$EndComp
Wire Wire Line
	4200 2550 4150 2550
Wire Wire Line
	4000 1850 3900 1850
Wire Wire Line
	3900 1850 3900 2050
Connection ~ 3900 2350
Wire Wire Line
	3900 2350 3600 2350
Wire Wire Line
	4000 1950 4000 2450
Wire Wire Line
	4000 2450 4150 2450
Wire Wire Line
	4150 2450 4150 2550
Connection ~ 4150 2550
Wire Wire Line
	4150 2550 4100 2550
$Comp
L Connector_Generic:Conn_01x04 J2
U 1 1 5F45461B
P 5450 4000
F 0 "J2" H 5400 4250 50  0000 L CNN
F 1 "Conn_01x04" H 5250 4350 50  0000 L CNN
F 2 "Connector:conn_01x04" H 5450 4000 50  0001 C CNN
F 3 "~" H 5450 4000 50  0001 C CNN
	1    5450 4000
	1    0    0    -1  
$EndComp
$Comp
L Connector_Generic:Conn_01x04 J3
U 1 1 5F4552B2
P 5650 4000
F 0 "J3" H 5650 3650 50  0000 C CNN
F 1 "Conn_01x04" H 5650 3550 50  0000 C CNN
F 2 "Connector:conn_01x04" H 5650 4000 50  0001 C CNN
F 3 "~" H 5650 4000 50  0001 C CNN
	1    5650 4000
	-1   0    0    -1  
$EndComp
Wire Wire Line
	6250 3900 6250 4000
Wire Wire Line
	6250 4100 6250 4000
Connection ~ 6250 4000
Wire Wire Line
	6250 4100 6250 4200
Wire Wire Line
	6250 4200 5850 4200
Connection ~ 6250 4100
Wire Wire Line
	5200 1950 5200 2050
Wire Wire Line
	3900 2050 5200 2050
Connection ~ 3900 2050
Wire Wire Line
	3900 2050 3900 2350
Connection ~ 5200 2050
Wire Wire Line
	5200 2050 5200 2550
$EndSCHEMATC
