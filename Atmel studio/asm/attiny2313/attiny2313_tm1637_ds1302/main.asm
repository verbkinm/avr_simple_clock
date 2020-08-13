;
; attiny2313_tm1637.asm
;
; Created: 30.06.2020 14:09:01
; Author : verbkinm
;

;##############################################
;##		����������� ������� �� �� 4-�		 ##
;##		���������� ������� � ����� TM1637,	 ##
;##		������ ������� ds1302. 				 ##
;##		���������� ����� ��������.			 ##
;##############################################

.include "tn2313adef.inc"
.include "def_equ.inc"

;------------------------- ������� ��� ����������

.def	BYTE			= r24		; ���� ������� � ���� ������ �� ds1302
.def	timer0_counter	= r25		; ������� ��� TIM0 ��� ����������� ��������� � �������� ��������������� ������
.def	timer0_counter_alarm_unlock	= r1		; ������� ��� ������������� ����������
.def	alarm_lock		= r2		; ���������� ����������
.def	CONST_ZERO		= r0		; ���������� ����
.def	tm_bright_level = r3

;------------------------- �������������� ����� ������

.dseg							; �������� ������� ���
	.org	0x60				; ������������� ������� ����� ��������

;------------------------- ���������� ����������

clock_mode:		.byte	1		; �������� ��������� ����������� (����� == 0, ���� == 1, ��� == 2)
mode:			.byte	1		; �������� ������� ��������, ������� ��������������� 
								; (������ �� ��������������� == 0, ���� == 1, ������ == 2, ����� == 3, ����� == 4, 
								; ��� == 5, ��������� ���\���� == 6, ���� ���������� == 7, ������ ���������� == 8,
								; ������� �������� �� ����� ������� ���������� == 9)
alarm:			.byte	1		; ��������� ������� == 1, �������� == 0,

;tm_bright_level: .byte	1		; ������� ������� �������

;------------------------- �������� ������ � ����������� ������� �� DS1302

bcd_minutes:	.byte	1		;
bcd_hours:		.byte	1		;
bcd_day:		.byte	1		;
bcd_month:		.byte	1		;
bcd_year:		.byte	1		;

;------------------------- �������� ������ � ����������� ������� ��� ����������

bcd_alarm_hours:	.byte	1
bcd_alarm_minutes:	.byte	1

;------------------------- �������� �������������� ������ ��� ����������� �� TM1637 �� ���������

tm_h1:			.byte	1		; ����
tm_h2:			.byte	1		; ����

tm_m1:			.byte	1		; ������
tm_m2:			.byte	1		; ������

tm_d1:			.byte	1		; ���� ������
tm_d2:			.byte	1		; ���� ������

tm_mt1:			.byte	1		; �����
tm_mt2:			.byte	1		; �����

tm_y1:			.byte	1		;
tm_y2:			.byte	1		;
tm_y3:			.byte	1		; ���
tm_y4:			.byte	1		; ���

tm_ah1:			.byte	1		; ���� ���������
tm_ah2:			.byte	1		; ���� ���������
tm_am1:			.byte	1		; ������ ���������
tm_am2:			.byte	1		; ������ ���������

ram_r17:		.byte	1
ram_r18:		.byte	1
ram_r19:		.byte	1

;------------------------- ������ ������������ ����

.cseg		 					; ����� �������� ������������ ����
	.org	0					; ��������� �������� ������ �� ����

start:	

.include "interrupts_vector.asm"
.include "interrupts.asm"
.include "initialization.asm"

	;-------------------------- ��������� �������� �� ���������

	ldi		r17, 31
	ldi		ZH, 0
	ldi		ZL, 0x60
	ldi		r16, 0

	clear_ram:
		dec		r17
		breq	clear_ram_end
		st		Z+, r16
		rjmp	clear_ram
	clear_ram_end:

	clr		timer0_counter
	clr		CONST_ZERO
	clr		timer0_counter_alarm_unlock
	clr		alarm_lock		

	ldi		r17, 0b00111111
	sts		tm_ah1, r17
	sts		tm_ah2, r17
	sts		tm_am1, r17
	sts		tm_am2, r17

	ldi		r17, 1
	;sts		tm_bright_level, r17
	mov		tm_bright_level, r17

	;-------------------------- ������ ��� ����� ����������� ���� 

	ldi		r17, 0b01011011	; 2
	sts		tm_y1, r17
	ldi		r17, 0b00111111	; 0
	sts		tm_y2, r17

	;-------------------------- ������ �������� ���������

	sei							; ���������� ����������

/*	ldi		r17, 0x14
	sts		bcd_alarm_hours, r17
	ldi		r17, 0x37
	sts		bcd_alarm_minutes, r17
	ldi		r17, 1
	sts		alarm, r17*/

	;-------------------------- ������� ������ 

	rcall	DS1302_read_package_data
	;rcall	_TIM1_A

	main:		
		sleep
		rjmp	main			; ������ ����������� ���� � �������� ����������

;-------------------------- ������ ������������� ����� � �������

max_day_in_month:	.db		31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31

.include "alarm.asm"
.include "ds1302.asm"
.include "tm1637.asm"
.include "lib.asm"
