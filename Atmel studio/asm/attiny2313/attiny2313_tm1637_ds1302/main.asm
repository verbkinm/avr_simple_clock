;
; attiny2313_tm1637.asm
;
; Created: 30.06.2020 14:09
; Recreate: 05.07.2021 11:46
; Author : verbkinm
;
; ��������:	
;	����������� ������� � ���� �� 4-� ���������� ������� � ����� TM1637, ������ ������� ds1302. 		
;	���������� ����� ��������, ���� ��������� � ��������� ������� �������.

.include "tn2313adef.inc"
.include "def_equ.inc"

.include "vars.asm"

;========================================================
;			 ������ ������������ ����
;========================================================

.cseg		 						; ����� �������� ������������ ����
	.org	0						; ��������� �������� ������ �� ����

start:	

	.include "interrupts_vector.asm"
	.include "interrupts.asm"
	.include "initialization.asm"

	;-------------------------- ������� ���� ���������, ����� �������� r0 � Z

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

	ldi		ZL,	 0x60
	ldi		r17, 28					; � ��� 27 ���������� = 28 ����� ������ ��������� � �����

	clear_ram:
		dec		r17
		breq	clear_ram_end
		st		Z+, CONST_ZERO
		rjmp	clear_ram
	clear_ram_end:	

	;-------------------------- ������ ��� ����� ����������� ���� (������ � �����) ��� TM1637

	ldi		ZH, high(tm_y1)
	ldi		ZL, low(tm_y1)

	ldi		r17, char_2
	st		Z+, r17
	ldi		r17, char_0
	st		Z+, r17

	;-------------------------- ���������� ������� ���������� �� EEPROM ��� ����������� �� ������� TM1637

	ldi		r17, bcd_alarm_hours
	rcall	EEPROM_read
	rcall	conv_ds1302_to_tm1637
	st		Z+, r16
	st		Z+, r15

	ldi		r17, bcd_alarm_minutes
	rcall	EEPROM_read
	rcall	conv_ds1302_to_tm1637
	st		Z+, r16
	st		Z, r15

	;-------------------------- �������. � Proteus � ����������� �������� ������ �� ������������!!!
	
	;ldi		r18, light		; ��� �������� 
	;ldi		r17, 0x01		; ��� ��������
	;rcall	EEPROM_write		; ��� ��������

	ldi		r17, light
	rcall	EEPROM_read

	mov		r18, r17
	rcall	bin_to_tm1637_digit
	sts		tm_light, r18
	mov		BYTE, r17
	rcall	TM1637_set_ligth

	rcall	TM1637_animation_1

	;-------------------------- ������� ������ � DS1302

	rcall	DS1302_read_package_data	; ������������� DS1302 - ������ ������� � DS1302 ����� ������� 
	rcall	DS1302_read_package_data	; �� ������������ (�� ������� ���� � ����), ��� ������ ������ �� ���������.

	;-------------------------- ������������� DS1302 - ���������� �� ������ � ��������� �����!

	ldi		BYTE, 0x8E
	rcall	DS1302_send_start
	rcall	DS1302_send_byte

	ldi		BYTE, 0x00

	rcall	DS1302_send_byte
	rcall	DS1302_send_stop	

	ldi		BYTE, 0x80
	rcall	DS1302_send_start
	rcall	DS1302_send_byte

	lds		BYTE, bcd_seconds
	andi	BYTE, 0x7F				; ��������� ������� ��� ����, ������������� ���� CH � ���� ��� ������� �����, ���� ���� �����������

	rcall	DS1302_send_byte
	rcall	DS1302_send_stop	

	sei								; ���������� ����������

	;-------------------------- �������� ����������� ���� � �������� ����������

	main:	 
		rjmp	main

.include "alarm.asm"
.include "ds1302.asm"
.include "tm1637.asm"
.include "lib.asm"
.include "delay.asm"

;-------------------------- ������ ������������� ����� � �������. ������ � ����� ����.

max_day_in_month:	.db		31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31

