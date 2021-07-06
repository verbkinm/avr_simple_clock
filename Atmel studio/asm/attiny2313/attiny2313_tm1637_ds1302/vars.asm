;========================================================
;			���������� ���������� � ���
;========================================================

.def	CONST_ZERO		= r0		; ���������� ����
.def	timer0_counter	= r1		; ������� ��� TIM0 ��� ����������� ���������
.def	tm1637_dot		= r2		; ���������� ��������� == 1, �� ���������� == 0
.def	blink_counter	= r3		; �������, ��� ���������� ������ mode !=0 ����� �� ����� mode_0
.def	dot_counter		= r4		; ������� ��� �������� ����������

.def	clock_mode		= r20		; �������� ��������� �������� ����������� (����� == 0, ������ � ������� == 1, ���� == 2)
.def	mode			= r21		; �������� ������� ��������, ������� ��������������� 
									; (������ �� ��������������� == 0, ���� == 1, ������ == 2, ����� == 3, ����� == 4, 
									; ��� == 5, ��������� ���\���� == 6, ���� ���������� == 7, ������ ���������� == 8,
									; ��������� ������� ������� == 9, ������� �������� �� ����� ������� ���������� == 10,
									; �������)

.def	BYTE			= r22		; ���� ��������\����� ������ ��\�� ds1302\tm1637

;========================================================
;			���������� ���������� � EEPROM
;========================================================

.eseg								; �������� ������� EEPROM
	.org	0x00					; ������������� ������� ����� ��������

;------------------------- �������� ������ ��� ���������� � �������

alarm_state:		.db		0x00	; ��������� �������� == 0,  ������� == 1
bcd_alarm_hours:	.db		0x07	; �� ��������� �������� �� 07:30
bcd_alarm_minutes:	.db		0x30
light:				.db		0x01	; ������� 

;========================================================
;				���������� ���������� � RAM
;========================================================

.dseg								; �������� ������� RAM
	.org	0x60					; ������������� ������� ����� ��������

;------------------------- �������� ������ � ����������� ������� �� DS1302

bcd_seconds:	.byte	1			;
bcd_minutes:	.byte	1			;
bcd_hours:		.byte	1			;
bcd_day:		.byte	1			;
bcd_month:		.byte	1			;
bcd_week_day:	.byte	1			;
bcd_year:		.byte	1			;

;------------------------- �������� �������������� ������ ��� ����������� �� TM1637 �����������

tm_s1:			.byte	1			; ������� ������
tm_s2:			.byte	1			; ������� ������

tm_m1:			.byte	1			; ������� �����
tm_m2:			.byte	1			; ������� �����

tm_h1:			.byte	1			; ������� �����
tm_h2:			.byte	1			; ������� ����

tm_d1:			.byte	1			; ������� ��� ������ 
tm_d2:			.byte	1			; ������� ��� ������

tm_mt1:			.byte	1			; ������� ������
tm_mt2:			.byte	1			; ������� ������

tm_wd1:			.byte	1			; ������� ���� ������ 
tm_wd2:			.byte	1			; ������� ���� ������ 

tm_y3:			.byte	1			; ������� ����
tm_y4:			.byte	1			; ������� ����

tm_light:		.byte	1			; ������� �������

;-------------------------- ������������������ ��������� ���������� �����!

tm_y1:			.byte	1			; ������ ����, ��� ����� ������������� �������� ������ �� ����
tm_y2:			.byte	1			; ����� ����, ��� ����� ������������� �������� ������ �� ����

tm_ah1:			.byte	1			; ������� ����� ����������
tm_ah2:			.byte	1			; ������� ����� ����������
tm_am1:			.byte	1			; ������� ����� ����������
tm_am2:			.byte	1			; ������� ����� ����������
