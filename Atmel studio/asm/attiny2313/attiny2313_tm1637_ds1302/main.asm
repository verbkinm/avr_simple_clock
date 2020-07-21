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

;------------------------- �������������� ����� ������

.dseg							; �������� ������� ���
	.org	0x60				; ������������� ������� ����� ��������

;------------------------- ���������� ����������

d1:				.byte	1 		;60 �������� ������� �������
d2:				.byte	1		;61 �������� ������� �������
double_point:	.byte	1		;62 �������� ��������� ������������ ��������� 
clock_mode:		.byte	1		;63 �������� ��������� ����������� (����� == 0, ���� == 1, ��� == 2)
mode:			.byte	1		;64 �������� ������� ��������, ������� ��������������� 
								; (������ �� ��������������� == 0, ���� == 1, ������ == 2, ����� == 3, ����� == 4, ��� == 5)

;------------------------- �������� ������ � ����������� ������� �� DS1302

var_minutes:	.byte	1		;65
var_hours:		.byte	1		;66
var_day:		.byte	1		;67
var_month:		.byte	1		;68
var_year:		.byte	1		;69

;------------------------- �������� ��� ��������

timer0_counter:	.byte	1		;6A
timer1_counter:	.byte	1		;6B

;------------------------- �������� �������������� ������ ��� ����������� �� TM1637 �� ���������

tm_h1:			.byte	1		;6C
tm_h2:			.byte	1		;6D

tm_m1:			.byte	1		;6E
tm_m2:			.byte	1		;6F

tm_d1:			.byte	1		;70
tm_d2:			.byte	1

tm_mt1:			.byte	1
tm_mt2:			.byte	1

tm_y1:			.byte	1		;
tm_y2:			.byte	1		;
tm_y3:			.byte	1		;
tm_y4:			.byte	1		;


;------------------------- ������ ������������ ����

.cseg		 					; ����� �������� ������������ ����
	.org	0					; ��������� �������� ������ �� ����

start:	

.include "interrupts_vector.asm"
.include "interrupts.asm"
.include "initialization.asm"

	;-------------------------- ������ �������� ���������

	sei						; ���������� ����������
	rcall	TM1637_display_dash

	;-------------------------- ����� ������ ����� ������������

	ldi		r17, 0x3c
	sts		timer1_counter, r17

	;-------------------------- ������ ��� ����� ����������� ���� 

	ldi		r17, 0b01011011	; 2
	sts		tm_y1, r17
	ldi		r17, 0b00111111	; 0
	sts		tm_y2, r17

main:		
	rjmp	main			; ������ ����������� ����

.include "ds1302.asm"
.include "tm1637.asm"
.include "data_convertor.asm"
