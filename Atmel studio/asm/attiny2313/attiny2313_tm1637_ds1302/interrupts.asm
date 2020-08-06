;========================================================
;       Подпрограммы обработки прерываний
;========================================================

;-------------------------- Прерывание при нажатии любой кнопки

_INT0_or_1:
	push	r17

	rcall	MCU_wait_20ms

	in		r17, PIND
	andi	r17, 0x0C

	cpi		r17, 0x08		; pd2 - int0
	breq	_INT01_MODE_press

	cpi		r17, 0x04		; pd3 - int1
	breq	_INT01_SET_press

	cpi		r17, 0x00		
	breq	_INT01_double_press

	rjmp	_INT0_or_1_end

	;-------------------------- Нажатие кнопки Mode

	_INT01_MODE_press:
		rcall	_INT0
		rjmp	_INT0_or_1_end

	;-------------------------- Нажатие кнопки Set

	_INT01_SET_press:
		rcall	_INT1
		rjmp	_INT0_or_1_end

	;-------------------------- Нажатие двух кнопок

	_INT01_double_press:
		in		r17, PIND
		andi	r17, 0x0C
		cpi		r17, 0x0C
		brne	_INT01_double_press


		lds		r17, tm_bright_level
		inc		r17
		cpi		r17, 0x08
		brlo	_INT01_double_press_set_bright
	
		clr		r17			

		_INT01_double_press_set_bright:
			sts		tm_bright_level, r17
			rcall	TM1637_set_bright

	_INT0_or_1_end:
		pop		r17

	reti


;-------------------------- Подпрограмма при нажатии кнопки Mode

_INT0:
	push	r17
	push	r16

	_INT0_wait_release:
		sbis	PIN_BUTTON_MODE, BUTTON_MODE
		rjmp	_INT0_wait_release

	rcall	DS1302_read_package_data


	ldi		r17, 0x00
	sts		clock_mode, r17

	;-------------------------- Инкремент переменной mode

	lds		r17, mode
	inc		r17

	;-------------------------- Выбор режима mode

	cpi		r17, 0x01
	breq	_INT0_mode_1

	cpi		r17, 0x02
	breq	_INT0_mode_2

	cpi		r17, 0x03
	breq	_INT0_mode_3

	cpi		r17, 0x04
	breq	_INT0_mode_4

	cpi		r17, 0x05
	breq	_INT0_mode_5

	cpi		r17, 0x06
	brsh	_INT0_mode_0

	rjmp	_INT0_end

	;------------------------- MODE 0

	_INT0_mode_0:
		rcall	DS1302_clock_on
		rcall	tim0_on
		rcall	TM1637_display_time

		;------------------------- Если день был установлен больше, чем максимальный в этом месяце, то данный код это исправляет.
		;------------------------- Пример: выставили 31 число, потом 9 месяц (а в сентябре 30 дней). При переходе в режим
		;------------------------- mode == 0 устанавливается 30 число!

		lds		r17, bcd_day
		rcall	bcd8bin
		mov		r16, r17
		rcall	get_max_day
		cp		r16, r17
		brlo	_INT0_mode_0_end
		ldi		BYTE, 0x86
		rcall	DS1302_send_start
		rcall	DS1302_send_byte
		mov		BYTE, r17
		rcall	bin8bcd
		rcall	DS1302_send_byte
		rcall	DS1302_send_stop

		_INT0_mode_0_end:
			ldi		r17, high(kdel2)	; меняем предделитель на 60 сек.
			out		OCR1AH, r17			 
			ldi		r17, low(kdel2)		 
			out		OCR1AL, r17	

			ldi		r17, 0x00

		rjmp	_INT0_end

	;------------------------- MODE 1

	_INT0_mode_1:
		rcall	tim0_off
		rcall	DS1302_clock_off
		rcall	TM1637_display_time
		rcall	TM1637_set_double_point

		ldi		r16, high(kdel1)	; меняем предделитель на 0,5 сек., чтобы моргало то, что мы меняем в режимах mode 1 - mode 5
		out		OCR1AH, r16 
		ldi		r16, low(kdel1)		 
		out		OCR1AL, r16
		ldi		r16, high(kdel1)	; чтобы сразу отобразилось
		out		TCNT1H, r16
		ldi		r16, low(kdel1-10)
		out		TCNT1L, r16

		rjmp	_INT0_end

	;------------------------- MODE 2

	_INT0_mode_2:
		rcall	TM1637_display_time
		rcall	TM1637_set_double_point

		rjmp	_INT0_end

	;------------------------- MODE 3

	_INT0_mode_3:
		rcall	TM1637_display_date

		rjmp	_INT0_end

	;------------------------- MODE 4

	_INT0_mode_4:
		rcall	TM1637_display_date

		rjmp	_INT0_end

	;------------------------- MODE 5

	_INT0_mode_5:
		rcall	TM1637_display_year

	_INT0_end:
		sts		mode, r17
		pop		r16
		pop		r17

	reti

;-------------------------- Подпрограмма при нажатии кнопки Clock mode \ Set

_INT1:
	push	r17

	_INT1_wait_release:
		sbis	PIN_BUTTON_SET, BUTTON_SET
		rjmp	_INT1_wait_release


	rcall	tim0_off

	lds		r17, mode
	cpi		r17, 0x00
	breq	_INT1_clock_mode_pressed

	;-------------------------- Режим Set

	_INT1_set_pressed:
		rcall	inc_circle

		rjmp	_INT1_end

	;-------------------------- Режим Clock mode

	_INT1_clock_mode_pressed:
		lds		r17, clock_mode
		inc		r17

		cpi		r17, 0x03
		brsh	_INT1_reset_clock_mode
		rjmp	_INT1_1

		_INT1_reset_clock_mode:
			rcall	tim0_on
			ldi		r17, 0x00

		_INT1_1:
			sts		clock_mode, r17

			;-------------------------- Чтобы данные сразу отобразились
			
			ldi		r17, high(kdel2)
			out		TCNT1H, r17
			ldi		r17, low(kdel2-10)
			out		TCNT1L, r17


	_INT1_end:
		pop		r17

	reti
	
;-------------------------- Прерывание таймера T1	


_TIM1:		
	push	r17
	push	r18
	push	r19
	
	lds		r17, mode
	cpi		r17, 0x00
	breq	rcall_TIM1_mode_0

	cpi		r17, 0x01
	breq	rcall_TIM1_mode_1

	cpi		r17, 0x02
	breq	rcall_TIM1_mode_2

	cpi		r17, 0x03
	breq	rcall_TIM1_mode_3

	cpi		r17, 0x04
	breq	rcall_TIM1_mode_4

	cpi		r17, 0x05
	breq	rcall_TIM1_mode_5

	;-------------------------- MODE 0

	rcall_TIM1_mode_0:

		;-------------------------- Считать данные с ds1302 пакетом

		rcall	DS1302_read_package_data

		lds		r17, clock_mode

		cpi		r17, 0x01
		breq	_TIM1_date_mode

		cpi		r17, 0x02
		breq	_TIM1_year_mode

		_TIM1_time_mode:
			rcall	TM1637_display_time
			rjmp	_TIM1_mode_0_reset_counter_end

		_TIM1_date_mode:
			rcall	TM1637_display_date
			rjmp	_TIM1_mode_0_reset_counter_end

		_TIM1_year_mode:
			rcall	TM1637_display_year

		_TIM1_mode_0_reset_counter_end:
			ldi		r17, 0x00

		_TIM1_mode_0_end:
			rcall	TM1637_display

		rjmp	_TIM1_end

	;-------------------------- MODE 1

	rcall_TIM1_mode_1:
		lds		r18, tm_h1
		lds		r19, tm_h2
		ldi		r17, 0x01
		rcall	TM1637_blink_pair

		rjmp	_TIM1_end

	;-------------------------- MODE 2

	rcall_TIM1_mode_2:
		lds		r18, tm_m1
		lds		r19, tm_m2
		ldi		r17, 0x02
		rcall	TM1637_blink_pair

		rjmp	_TIM1_end

	;-------------------------- MODE 3

	rcall_TIM1_mode_3:
		lds		r18, tm_d1
		lds		r19, tm_d2
		ldi		r17, 0x01
		rcall	TM1637_blink_pair

		rjmp	_TIM1_end

	;-------------------------- MODE 4

	rcall_TIM1_mode_4:
		lds		r18, tm_mt1
		lds		r19, tm_mt2
		ldi		r17, 0x02
		rcall	TM1637_blink_pair

		rjmp	_TIM1_end

	;-------------------------- MODE 5

	rcall_TIM1_mode_5:
		lds		r18, tm_y3
		lds		r19, tm_y4
		ldi		r17, 0x03
		rcall	TM1637_blink_pair


	_TIM1_end:
		pop		r19
		pop		r18
		pop		r17
		
	reti
	
;-------------------------- Прерывание таймера T0

_TIM0:
	push	r17
	push	BYTE

	inc		timer0_counter
	cpi		timer0_counter, 0x03
	brne	_TIM0_end

	clr		timer0_counter

	;-------------------------- Для экономии работы микроконтроллеров. Изменяется только значение 2-го элемента на дисплее, а не всех!!!

	rcall	TM1637_start
	ldi		BYTE, 0x44
	rcall	TM1637_send_byte
	rcall	TM1637_stop

	rcall	TM1637_start
	ldi		BYTE, 0xC1
	rcall	TM1637_send_byte
	lds		BYTE, tm_h2
	ldi		r17, 0x80
	eor		BYTE, r17
	sts		tm_h2, BYTE
	rcall	TM1637_send_byte
	rcall	TM1637_stop

	_TIM0_end:
		pop		BYTE
		pop		r17

	reti


tim0_on:
	push	r17
	ldi		r17, (1 << WGM01)							 ; Выбор режима таймера СТС 
	out		TCCR0A, r17
	ldi		r17, (1 << CS02) | (0 << CS01) | (1 << CS00) ; Выбор предделителя = 1024 
	out		TCCR0B, r17
	pop		r17

	ret

tim0_off:
	push	r17
	ldi		r17, (0 << CS02) | (0 << CS01) | (0 << CS00) ; Выбор предделителя = 1024 
	out		TCCR0B, r17
	pop		r17

	ret