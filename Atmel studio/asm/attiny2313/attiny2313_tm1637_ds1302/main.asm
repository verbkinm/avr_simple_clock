;
; attiny2313_tm1637.asm
;
; Created: 30.06.2020 14:09:01
; Author : verbkinm
;

;##############################################
;##		Отображение времени на на 4-х		 ##
;##		елементном дисплее с чипом TM1637,	 ##
;##		модуль времени ds1302. 				 ##
;##		Управление двумя кнопками.			 ##
;##############################################

.include "tn2313adef.inc"
.include "def_equ.inc"

;------------------------- Регистр как переменные

.def	BYTE			= r24		; байт отсылки и приём данных из ds1302
.def	timer0_counter	= r25		; счетчик для TIM0 при отображении двоеточия и моргания устанавливаемых данных
.def	timer0_counter_alarm_unlock	= r1		; счетчик для разблоктровки будильника
.def	alarm_lock		= r2		; блокировка будильника
.def	CONST_ZERO		= r0		; постоянный ноль
.def	tm_bright_level = r3

;------------------------- Резервирование ячеек памяти

.dseg							; Выбираем сегмент ОЗУ
	.org	0x60				; Устанавливаем текущий адрес сегмента

;------------------------- Глобальные переменные

clock_mode:		.byte	1		; Храниние состояния отображения (время == 0, дата == 1, год == 2)
mode:			.byte	1		; Храниние позиции элемента, который устанавливается 
								; (ничего не устанавливается == 0, часы == 1, минуты == 2, чисдо == 3, месяц == 4, 
								; год == 5, будильник вкл\выкл == 6, часы будильника == 7, минуты будильника == 8,
								; моргать временем во время сигнала будильника == 9)
alarm:			.byte	1		; будильник включён == 1, выключен == 0,

;tm_bright_level: .byte	1		; уровень яркости дисплея

;------------------------- Хранение данных в упаковонном формате от DS1302

bcd_minutes:	.byte	1		;
bcd_hours:		.byte	1		;
bcd_day:		.byte	1		;
bcd_month:		.byte	1		;
bcd_year:		.byte	1		;

;------------------------- Хранение данных в упаковонном формате для будильника

bcd_alarm_hours:	.byte	1
bcd_alarm_minutes:	.byte	1

;------------------------- Хранение подготовленных данных для отображения на TM1637 по элементно

tm_h1:			.byte	1		; часы
tm_h2:			.byte	1		; часы

tm_m1:			.byte	1		; минуты
tm_m2:			.byte	1		; минуты

tm_d1:			.byte	1		; день месяца
tm_d2:			.byte	1		; день месяца

tm_mt1:			.byte	1		; месяц
tm_mt2:			.byte	1		; месяц

tm_y1:			.byte	1		;
tm_y2:			.byte	1		;
tm_y3:			.byte	1		; год
tm_y4:			.byte	1		; год

tm_ah1:			.byte	1		; часы будильник
tm_ah2:			.byte	1		; часы будильник
tm_am1:			.byte	1		; минуты будильник
tm_am2:			.byte	1		; минуты будильник

ram_r17:		.byte	1
ram_r18:		.byte	1
ram_r19:		.byte	1

;------------------------- Начало программного кода

.cseg		 					; Выбор сегмента программного кода
	.org	0					; Установка текущего адреса на ноль

start:	

.include "interrupts_vector.asm"
.include "interrupts.asm"
.include "initialization.asm"

	;-------------------------- Установка значение по умолчанию

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

	;-------------------------- Первые две цифры отображения года 

	ldi		r17, 0b01011011	; 2
	sts		tm_y1, r17
	ldi		r17, 0b00111111	; 0
	sts		tm_y2, r17

	;-------------------------- Начало основной программы

	sei							; Разрешение прерываний

/*	ldi		r17, 0x14
	sts		bcd_alarm_hours, r17
	ldi		r17, 0x37
	sts		bcd_alarm_minutes, r17
	ldi		r17, 1
	sts		alarm, r17*/

	;-------------------------- Считать данные 

	rcall	DS1302_read_package_data
	;rcall	_TIM1_A

	main:		
		sleep
		rjmp	main			; Пустой бесконечный цикл в ожидании прерывания

;-------------------------- Массив максимального числа в месяцах

max_day_in_month:	.db		31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31

.include "alarm.asm"
.include "ds1302.asm"
.include "tm1637.asm"
.include "lib.asm"
