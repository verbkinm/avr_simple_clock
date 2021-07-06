;
; attiny2313_tm1637.asm
;
; Created: 30.06.2020 14:09
; Recreate: 05.07.2021 11:46
; Author : verbkinm
;
; Описание:	
;	Отображение времени и даты на 4-х елементном дисплее с чипом TM1637, модуль времени ds1302. 		
;	Управление двумя кнопками, есть будильник и настройка яркости дисплея.

.include "tn2313adef.inc"
.include "def_equ.inc"

.include "vars.asm"

;========================================================
;			 Начало программного кода
;========================================================

.cseg		 						; Выбор сегмента программного кода
	.org	0						; Установка текущего адреса на ноль

start:	

	.include "interrupts_vector.asm"
	.include "interrupts.asm"
	.include "initialization.asm"

	;-------------------------- Очистка всех регистров, кроме регистра r0 и Z

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

	;-------------------------- Очистка RAM под наши переменные

	ldi		ZL,	 0x60
	ldi		r17, 28					; У нас 27 переменных = 28 минус первый декремент в цикле

	clear_ram:
		dec		r17
		breq	clear_ram_end
		st		Z+, CONST_ZERO
		rjmp	clear_ram
	clear_ram_end:	

	;-------------------------- Первые две цифры отображения года (тысячи и сотни) для TM1637

	ldi		ZH, high(tm_y1)
	ldi		ZL, low(tm_y1)

	ldi		r17, char_2
	st		Z+, r17
	ldi		r17, char_0
	st		Z+, r17

	;-------------------------- Считывание времени будильника из EEPROM для отображения на дисплее TM1637

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

	;-------------------------- Яркость. В Proteus с минимальной яркостью ничего не отображается!!!
	
	;ldi		r18, light		; для протеуса 
	;ldi		r17, 0x01		; для протеуса
	;rcall	EEPROM_write		; для протеуса

	ldi		r17, light
	rcall	EEPROM_read

	mov		r18, r17
	rcall	bin_to_tm1637_digit
	sts		tm_light, r18
	mov		BYTE, r17
	rcall	TM1637_set_ligth

	rcall	change_tim0_to_buzzer_mode
	rcall	TM1637_animation_1
	rcall	change_tim0_off

	;-------------------------- Считать данные с DS1302

	rcall	DS1302_read_package_data	; инициализация DS1302 - первая команда в DS1302 после запуска 
	rcall	DS1302_read_package_data	; МК игнорируется (по крайней мере у меня), без данной строки не сработает.

	;-------------------------- Инициализация DS1302 - разрешение на запись и включение часов!

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
	andi	BYTE, 0x7F				; Оставляем секунды как были, устанавливаем флаг CH в ноль для запуска часов, если были остановлены

	rcall	DS1302_send_byte
	rcall	DS1302_send_stop	

	sei								; Разрешение прерываний

	;-------------------------- Основной бесконечный цикл в ожидании прерывания

	main:	 
		rjmp	main

.include "alarm.asm"
.include "ds1302.asm"
.include "tm1637.asm"
.include "lib.asm"
.include "delay.asm"
.include "tim0.asm"
.include "eeprom_rw.asm"

;-------------------------- Массив максимального числа в месяцах. Убрано в конец кода.

max_day_in_month:	.db		31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31

