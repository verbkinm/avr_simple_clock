;========================================================
;	Подпрограммы для моргания 3-м и 4-м элементами
;	в режиме включения\выключения будильника
;========================================================

alarm_blink:
	push	r17
	push	r18
	push	r19

	sbrc	alarm, 0
	ldi		r19, char_N	
	sbrs	alarm, 0
	ldi		r19, char_F	

	ldi		r18, char_O	

	ldi		r17, 0x02
	rcall	TM1637_blink_pair
	
	pop		r19
	pop		r18
	pop		r17

	ret

;========================================================
;				Инкремент для будильника
;========================================================

inc_cicle_alarm:
	push	r17
	push	r18
	push	r19
	push	BYTE

	mov		r19, CONST_ZERO			; минимальное число для инкремента во всех ниже случаях

	cpi		mode, mode_6
	breq	inc_circle_alarm_switch

	cpi		mode, mode_7
	breq	inc_circle_alarm_hour

	cpi		mode, mode_8
	breq	inc_circle_alarm_minutes

	rjmp	inc_cicle_alarm_end

	;-------------------------- Вкл.\выкл. будильника 

	inc_circle_alarm_switch:
		mov		r17, alarm
		ldi		r18, 2
		rcall	_inc
		mov		alarm, r17

		rcall	TM1637_display_alarm_mode
		clr		alarm_lock							; снять блокировку будильника

		rjmp	inc_cicle_alarm_end

	;-------------------------- Выставление часов будильника

	inc_circle_alarm_hour:
		ldi		r17, bcd_alarm_hours
		rcall	EEPROM_read

		rcall	bcd8bin
		ldi		r18, 24
		rcall	_inc
		rcall	bin8bcd

		ldi		r18, bcd_alarm_hours
		rcall	EEPROM_write

		rcall	conv_ds1302_to_tm1637
		sts		tm_ah1, r16
		sts		tm_ah2, r15

		rcall	TM1637_display_alarm

		rjmp	inc_cicle_alarm_end

	;-------------------------- Выставление минут будильника

	inc_circle_alarm_minutes:
		ldi		r17, bcd_alarm_minutes
		rcall	EEPROM_read

		rcall	bcd8bin
		ldi		r18, 60
		rcall	_inc
		rcall	bin8bcd

		ldi		r18, bcd_alarm_minutes
		rcall	EEPROM_write

		rcall	conv_ds1302_to_tm1637
		sts		tm_am1, r16
		sts		tm_am2, r15

		rcall	TM1637_display_alarm

	inc_cicle_alarm_end:
		pop		BYTE
		pop		r19
		pop		r18
		pop		r17

	ret

;========================================================
;				Включить будильник
;========================================================

alarm_on:
	push	r18
	push	r17
	push	r16

	out		GIMSK, CONST_ZERO			; отключить прерывания от кнопок 

	rcall	TM1637_display_time

	ldi		mode, mode_9				; mode_9 включается только во время срабатывания будильника

	rcall	change_tim1_to_blink_mode
	rcall	change_tim0_to_buzzer_mode

	sei									; т.к. процедура "alarm_on" вызывается из прерывания TIM1, то до этого момента прерывания отключены 

	;-------------------------- ~ 1 мин. 10 сек. Данный цикл + его команды + прерывание на таймер с его командами. Нужно, чтобы будильник сам выключился через время, а не звонил вечно, до самого обеда!

	ldi		r17, 5
	ser		r16
	alarm_on_wait_loop_L:
		rcall	MCU_wait_20ms

		in		r18, PIND
		andi	r18, 0x0C
		cpi		r18, 0x0C
		brlo	alarm_off

		dec		r16
		brne	alarm_on_wait_loop_L

		alarm_on_wait_loop_H:
			ser		r16
			dec		r17
			brne	alarm_on_wait_loop_L

	;-------------------------- Отключение будильника через время или по нажатию любой кнопки

	alarm_off:
		cli
		rcall	change_tim1_to_normal_mode
		rcall	change_tim0_to_normal_mode
		rcall	TM1637_display_time
		clr		mode
		ldi		r16, 0x01			; Блокировка будильника
		mov		alarm_lock, r16
		
		;-------------------------- Если будильник был отключён по нажатию кнопки, ждем, когда эту кнопку отпустит =))

		alarm_off_wait_release:
			rcall	MCU_wait_20ms
			in		r17, PIND
			andi	r17, 0x0C
			cpi		r17, 0x0C
			brne	alarm_off_wait_release

		;-------------------------- Разрешить прерывания от кнопок 

		ldi		r17, (1 << INT0) | (1 << INT1)	
		out		GIMSK, r17
		sei

	pop		r16
	pop		r17
	pop		r18

	ret

;========================================================
;			Подпрограмма проверки будильника
;========================================================

alarm_check:
	push	r18
	push	r17

	sbrs	alarm, 0					
	rjmp	to_alarm_end				; Если будильник отключён, то выходим из процедуры
	sbrc	alarm_lock, 0
	rjmp	to_alarm_end				; Если будильник блокирован отключён, то выходим из процедуры

	ldi		r17, bcd_alarm_hours		; Адрес переменной "bcd_alarm_hours" из EEPROM в регистр r17
	rcall	EEPROM_read					; Результат в регистр r17
	lds		r18, bcd_hours				; Текущие часы в регистр r18
	cp		r17, r18					; Сравниваем текущие часы с часами будильника
	brne	to_alarm_end				; Если текущие часы не совпадают с часами будильника - выходим из процедуры

	ldi		r17, bcd_alarm_minutes		; Адрес переменной "bcd_alarm_minutes" из EEPROM в регистр r17
	rcall	EEPROM_read					; Результат в регистр r17
	lds		r18, bcd_minutes			; Текущие минуты в регистр r18
	cpse	r17, r18					; Сравниваем текущие минуты с минутами будильника
	rjmp	to_alarm_end				; Если текущие минуты не совпадают с минутами будильника - выходим из процедуры

	rcall	alarm_on					; Если всё совпало - включить будильник

	to_alarm_end:
		pop		r17
		pop		r18

	ret
