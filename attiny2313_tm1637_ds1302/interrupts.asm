;========================================================
;       Подпрограммы обработки прерываний
;========================================================

;-------------------------- Прерывание при нажатии кнопки Mode

_INT0:
		push	r17

	;-------------------------- Инкремент переменной mode

		ldi		r17, 0x00
		sts		clock_mode, r17
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
		rcall	TM1637_display_time
		ldi		r17, 0x00

		rjmp	_INT0_end

	;------------------------- MODE 1

	_INT0_mode_1:
		rcall	DS1302_clock_off
		rcall	TM1637_display_time
		rcall	TM1637_set_double_point

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
		pop		r17

	reti

;-------------------------- Прерывание при нажатии кнопки Clock mode \ Set

_INT1:
		push	r17

		lds		r17, mode
		cpi		r17, 0x00
		breq	_INT1_clock_mode_pressed

	;-------------------------- Режим Set

	_INT1_set_pressed:
		rcall	inc_circle

		rjmp	_INT1_end

	;-------------------------- Режим Clock mode

	_INT1_clock_mode_pressed:
		ldi		r17, 0x00
		out		TCCR1B, r17 ; выключить таймер

		rcall	TM1637_display_dash

		lds		r17, clock_mode
		inc		r17

		cpi		r17, 0x03
		brsh	_INT1_reset_clock_mode
		rjmp	_INT1_1

		_INT1_reset_clock_mode:
			ldi		r17, 0x00

		_INT1_1:
			sts		clock_mode, r17

			ldi		r17, (1 << WGM12) | (1 << CS12) | (0 << CS11) | (1 << CS10) ; Выбор режима таймера (СТС, предделитель = 1024) 
			out		TCCR1B, r17
			ldi		r17, high(kdel2)
			out		TCNT1H, r17
			ldi		r17, low(kdel2)
			out		TCNT1L, r17

			;-------------------------- Чтобы данные сразу отобразились

			ldi		r17, 0x3c
			sts		timer1_counter, r17

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
		lds		r17, timer1_counter
		inc		r17

		cpi		r17, 0x3c
		brsh	_TIM1_mode_0_reset_counter
		rjmp	_TIM1_mode_0_end

		_TIM1_mode_0_reset_counter:

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
				sts		timer1_counter, r17
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
	
;-------------------------- Прерывание таймера T1	

_TIM0:
	push	r17
	push	r16

	;-------------------------- Отработать прерывание, если clock_mode == 0

	lds		r17, clock_mode
	lds		r16, mode
	or		r16, r17
	brne	_TIM0_end

	lds		r17, timer0_counter
	inc		r17

	;-------------------------- Моргать двоеточием раз в пол секунды

	cpi		r17, 0x0f
	brsh	_TIM0_reset_counter
	rjmp	_TIM0_end

	_TIM0_reset_counter:
		lds		r17, double_point

		cpi		r17, 0x00
		breq	_TIM0_set_double_point

		rcall	TM1637_unset_double_point
		rjmp	_TIM0_reset_counter_end

		_TIM0_set_double_point:
			rcall	TM1637_set_double_point

	_TIM0_reset_counter_end:
		ldi		r17, 0x00

	_TIM0_end:
		sts		timer0_counter, r17
		pop		r16
		pop		r17

	reti

