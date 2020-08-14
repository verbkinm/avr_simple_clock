;
; attiny2313_tm1637.asm
;
; Created: 30.06.2020 14:09:01
; Author : verbkinm
;
; ��������:	
;	����������� ������� � ���� �� 4-� ���������� ������� � ����� TM1637, ������ ������� ds1302. 		
;	���������� ����� ��������, ���� ���������.

.include "tn2313adef.inc"
.include "def_equ.inc"

;========================================================
;			���������� ���������� � ���������
;========================================================

.def	BYTE			= r24		; ���� ������� � ���� ������ �� ds1302

.def	timer0_counter	= r25		; ������� ��� TIM0 ��� ����������� ��������� � �������� ��������������� ������
.def	timer0_counter_alarm_unlock	= r1	; ������� ��� ������������� ����������

.def	CONST_ZERO		= r0		; ���������� ����

.def	alarm			= r2		; �������� == 0, ��������� ������� == 1,
.def	alarm_lock		= r3		; ���������� ����������, ���������� == 1, ������������� == 0

.def	tm_bright_level = r4		; ������� ������� �������, 0..

.def	clock_mode		= r5		; �������� ��������� ����������� (����� == 0, ���� == 1, ��� == 2)
.def	mode			= r6		; �������� ������� ��������, ������� ��������������� 
									; (������ �� ��������������� == 0, ���� == 1, ������ == 2, ����� == 3, ����� == 4, 
									; ��� == 5, ��������� ���\���� == 6, ���� ���������� == 7, ������ ���������� == 8,
									; ������� �������� �� ����� ������� ���������� == 9)

;========================================================
;			���������� ���������� � EEPROM
;========================================================

.eseg
	.org	0x00

;------------------------- �������� ������ � ����������� ������� ��� ����������

bcd_alarm_hours:	.db		0x00
bcd_alarm_minutes:	.db		0x00

;========================================================
;				���������� ���������� � RAM
;========================================================

;------------------------- �������������� ����� ������

.dseg							; �������� ������� ���
	.org	0x60				; ������������� ������� ����� ��������

;------------------------- �������� ������ � ����������� ������� �� DS1302

bcd_minutes:	.db	1		;
bcd_hours:		.byte	1		;
bcd_day:		.byte	1		;
bcd_month:		.byte	1		;
bcd_year:		.byte	1		;

;------------------------- �������� �������������� ������ ��� ����������� �� TM1637 �� ���������

tm_h1:			.byte	1		; ����
tm_h2:			.byte	1		; ����

tm_m1:			.byte	1		; ������
tm_m2:			.byte	1		; ������

tm_d1:			.byte	1		; ���� ������
tm_d2:			.byte	1		; ���� ������

tm_mt1:			.byte	1		; �����
tm_mt2:			.byte	1		; �����

tm_y3:			.byte	1		; ���
tm_y4:			.byte	1		; ���
tm_y1:			.byte	1		; ��� ����� ������������� �������� ������ �� ����
tm_y2:			.byte	1		; ��� ����� ������������� �������� ������ �� ����

tm_ah1:			.byte	1		; ���� ���������
tm_ah2:			.byte	1		; ���� ���������
tm_am1:			.byte	1		; ������ ���������
tm_am2:			.byte	1		; ������ ���������

;========================================================
;			 ������ ������������ ����
;========================================================

.cseg		 					; ����� �������� ������������ ����
	.org	0					; ��������� �������� ������ �� ����

start:	

	.include "interrupts_vector.asm"
	.include "interrupts.asm"
	.include "initialization.asm"

	;-------------------------- ������� ���� ���������

	clr		CONST_ZERO

	ldi		ZH, 0
	ldi		ZL, 2

	ldi		r17, 29
	mov		r1, r17

	clear_reg:
		dec		r1
		breq	clear_reg_end
		st		Z+, CONST_ZERO
		rjmp	clear_reg
	clear_reg_end:	

	;-------------------------- ������� RAM ��� ���� ����������

	ldi		ZH, 0
	ldi		ZL, 0x60
	ldi		r17, 22				; � ��� 21 ���������� = 22 ����� ������ ��������� � �����

	clear_ram:
		dec		r17
		breq	clear_ram_end
		st		Z+, CONST_ZERO
		rjmp	clear_ram
	clear_ram_end:	

	;-------------------------- ������ ��� ����� ����������� ���� 

	ldi		ZH, high(tm_y1)
	ldi		ZL, low(tm_y1)

	ldi		r17, 0b01011011	; 2
	st		Z+, r17
	ldi		r17, 0b00111111	; 0
	st		Z+, r17

	;-------------------------- ���������� ������� ���������� �� EEPROM ��� ����������� �� �������

	ldi		r18, bcd_alarm_hours
	rcall	EEPROM_read
	rcall	conv_ds1302_to_tm1637
	st		Z+, r16
	st		Z+, r15

	ldi		r18, bcd_alarm_minutes
	rcall	EEPROM_read
	rcall	conv_ds1302_to_tm1637
	st		Z+, r16
	st		Z, r15

	;-------------------------- � Proteus � ����������� �������� ������ �� ������������ 

	ldi		r17, 1
	mov		tm_bright_level, r17

	sei							; ���������� ����������

	;-------------------------- ������� ������ � DS1302

	rcall	DS1302_read_package_data

	main:		
		sleep
		rjmp	main			; ������ ����������� ���� � �������� ����������

;-------------------------- ������ ������������� ����� � �������

max_day_in_month:	.db		31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31

.include "alarm.asm"
.include "ds1302.asm"
.include "tm1637.asm"
.include "lib.asm"
