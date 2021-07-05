;========================================================
;	Подпрограммы для моргания 3-м и 4-м элементами
;	в режиме включения\выключения будильника
;========================================================
 
alarm_blink:
	push	r17
	push	r18
	push	r19

	ldi		r17, alarm_state
	rcall	EEPROM_read

	sbrc	r17, 0
	ldi		r19, char_N	
	sbrs	r17, 0
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
		ldi		r17, alarm_state
		rcall	EEPROM_read

		ldi		r18, 2
		rcall	_inc

		ldi		r18, alarm_state
		rcall	EEPROM_write

		rcall	TM1637_display_alarm_mode

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
;			Подпрограмма проверки будильника
;========================================================

alarm_check:
	push	r18
	push	r17

	ldi		r17, alarm_state
	rcall	EEPROM_read

	sbrs	r17, 0					
	rjmp	to_alarm_end				; Если будильник отключён, то выходим из процедуры

	ldi		r17, bcd_alarm_hours		; Адрес переменной "bcd_alarm_hours" из EEPROM в регистр r17
	rcall	EEPROM_read					; Результат в регистр r17
	lds		r18, bcd_hours				; Текущие часы в регистр r18
	cp		r17, r18					; Сравниваем текущие часы с часами будильника
	brne	to_alarm_end				; Если текущие часы не совпадают с часами будильника - выходим из процедуры

	ldi		r17, bcd_alarm_minutes		; Адрес переменной "bcd_alarm_minutes" из EEPROM в регистр r17
	rcall	EEPROM_read					; Результат в регистр r17
	lds		r18, bcd_minutes			; Текущие минуты в регистр r18
	cp		r17, r18					; Сравниваем текущие минуты с минутами будильника
	brne	to_alarm_end				; Если текущие минуты не совпадают с минутами будильника - выходим из процедуры

	lds		r18, bcd_seconds			; сравниваем текущие секунды с нулём
	cpi		r18, 0x00
	brne	to_alarm_end

										; Включить будильник
	rcall	TM1637_display_time
	ldi		mode, mode_10				; mode_10 включается только во время срабатывания будильника
	rcall	change_tim0_to_buzzer_mode


	to_alarm_end:
		pop		r17
		pop		r18

	ret
