;========================================================
;	Подпрограммы для моргания 3 и 4 элементов
;	в режиме включения\выключения будильника
;========================================================

alarm_blink:
	rcall	push_17_18_19

	lds		r18, alarm
	sbrc	r18, 0
	ldi		r19, char_N	; N
	sbrs	r18, 0
	ldi		r19, char_F	; F

	ldi		r18, char_O	; O

	ldi		r17, 0x02
	rcall	TM1637_blink_pair
	
	rcall	pop_19_18_17

	ret

;========================================================
;		Инкремент для будильника
;========================================================

;-------------------------- Будильник вкл.\выкл.
inc_cicle_alarm:
	rcall	push_17_18_19
	push	BYTE

	lds		r17, mode

	cpi		r17, 0x06
	breq	inc_circle_alarm_switch

	cpi		r17, 0x07
	breq	inc_circle_alarm_hour

	cpi		r17, 0x08
	breq	inc_circle_alarm_minutes

	rjmp	inc_cicle_alarm_end

	inc_circle_alarm_switch:
		lds		r17, alarm
		ldi		r19, 0
		ldi		r18, 2
		rcall	_inc
		sts		alarm, r17

		rcall	TM1637_display_alarm_mode
		clr		alarm_lock				; снять блокировкку будильника

		rjmp	inc_cicle_alarm_end

	;-------------------------- Будильник часы

	inc_circle_alarm_hour:
		lds		r17, bcd_alarm_hours
		rcall	bcd8bin
		ldi		r19, 0
		ldi		r18, 24
		rcall	_inc
		mov		BYTE, r17
		rcall	bin8bcd
		sts		bcd_alarm_hours, BYTE
		rcall	conv_ds1302_to_tm1637
		sts		tm_ah1, r16
		sts		tm_ah2, r15
		rcall	TM1637_display_alarm

		rjmp	inc_cicle_alarm_end

	;-------------------------- Будильник минуты

	inc_circle_alarm_minutes:
		lds		r17, bcd_alarm_minutes
		rcall	bcd8bin
		ldi		r19, 0
		ldi		r18, 60
		rcall	_inc
		mov		BYTE, r17
		rcall	bin8bcd
		sts		bcd_alarm_minutes, BYTE
		rcall	conv_ds1302_to_tm1637
		sts		tm_am1, r16
		sts		tm_am2, r15
		rcall	TM1637_display_alarm

	inc_cicle_alarm_end:
		pop		BYTE
		rcall	pop_19_18_17

	ret

;========================================================
;			Включить будильник
;========================================================

alarm_on:
	push	r18
	push	r17
	push	r16

	ldi		r17, (0 << INT0) | (0 << INT1)
	out		GIMSK, r17

	rcall	TM1637_display_time

	ldi		r17, 0x09
	sts		mode, r17

	rcall	change_tim1_to_blink_mode
	rcall	change_tim0_to_buzzer_mode
	sei

	;-------------------------- ~ 1 мин. 10 сек. Данный цикл + его команды + прерывание на таймер с его командами

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

	alarm_off:
		cli
		rcall	change_tim1_to_normal_mode
		rcall	change_tim0_to_normal_mode
		rcall	TM1637_display_time
		sts		mode, CONST_ZERO
		ldi		r16, 0x01
		mov		alarm_lock, r16
		
		alarm_off_wait_release:
		rcall	MCU_wait_20ms
		in		r17, PIND
		andi	r17, 0x0C
		cpi		r17, 0x0C
		brne	alarm_off_wait_release

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

	lds		r17, alarm
	sbrs	r17, 0
	rjmp	to_alarm_end
	sbrc	alarm_lock, 0
	rjmp	to_alarm_end

	lds		r17, bcd_hours
	lds		r18, bcd_alarm_hours
	cp		r17, r18
	brne	to_alarm_end

	lds		r17, bcd_minutes
	lds		r18, bcd_alarm_minutes
	cpse	r17, r18
	rjmp	to_alarm_end

	rcall	alarm_on

	to_alarm_end:
		pop		r17
		pop		r18

	ret
