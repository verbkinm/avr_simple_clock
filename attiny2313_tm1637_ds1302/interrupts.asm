;========================================================
;       Подпрограммы обработки прерываний
;========================================================

;-------------------------- Прерывание при нажатии кнопки Mode

_INT0:
		push	r17
		push	r18

	;-------------------------- Инкремент переменной mode

		lds		r18, mode
		inc		r18

	;-------------------------- Выбор режима mode

		cpi		r18, 0x01
		breq	_INT0_mode_1

		cpi		r18, 0x06
		brsh	_INT0_mode_0

		rjmp	_INT0_end

	;------------------------- MODE 0

	_INT0_mode_0:

	;------------------------- Режим mode -> 0, запустить таймер в нормальном режиме

		ldi		r18, 0x00
		ldi		r17, high(kdel1)
		out		OCR1AH, r17
		ldi		r17, low(kdel1)
		out		OCR1AL, r17

		rjmp	_INT0_end

	;------------------------- MODE 1

	_INT0_mode_1:

	;-------------------------- Частота моргания 0,5 сек.

		ldi		r17, high(kdel2)
		out		OCR1AH, r17
		ldi		r17, low(kdel2)
		out		OCR1AL, r17

		ldi		r17, 0x00
		out		TCNT1H, r17
		out		TCNT1L, r17

	;-------------------------- Считать данные с ds1302 пакетом

		rcall	DS1302_read_package_data
		
		rjmp	_INT0_end

	_INT0_end:
		sts		mode, r18
		pop		r18
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
		ldi		r17, high(kdel0)
		out		TCNT1H, r17
		ldi		r17, low(kdel0)
		out		TCNT1L, r17

	_INT1_end:
		pop		r17
	reti
	
;-------------------------- Прерывание таймера T1	

_TIM1:		

	push	r17
	push	r18

	lds		r17, mode
	cpi		r17, 0x00
	breq	_TIM1_mode_0

	cpi		r17, 0x01
	breq	_TIM1_mode_1

	cpi		r17, 0x02
	breq	_TIM1_mode_2

	cpi		r17, 0x03
	breq	_TIM1_mode_3

/*	cpi		r17, 0x04
	breq	_TIM1_mode_4

	cpi		r17, 0x05
	breq	_TIM1_mode_5*/

	;-------------------------- MODE 0

	_TIM1_mode_0:
		lds		r17, clock_mode

		cpi		r17, 0x00
		breq	_TIM1_time_mode

		cpi		r17, 0x01
		breq	_TIM1_date_mode

		cpi		r17, 0x02
		breq	_TIM1_year_mode

	_TIM1_time_mode:
		ldi		r17, 0x85
		ldi		r18, 0x83
		rjmp	_TIM1_prepare_display

	_TIM1_date_mode:
		ldi		r17, 0x87
		ldi		r18, 0x89
		rjmp	_TIM1_prepare_display

	_TIM1_year_mode:
		ldi		r18, 0x8D

	_TIM1_prepare_display:
		rcall	prepare_display

	;-------------------------- Вывести результат на дисплей tm1637

		rcall	TM1637_display

		rjmp	_TIM1_end

	;-------------------------- MODE 1

	_TIM1_mode_1:
		lds		BYTE, hours
		rcall	conv_ds1302_to_tm1637
		lds		r17, d1
		eor		TM1637_d1, r17
		lds		r17, d2
		eor		TM1637_d2, r17
		lds		BYTE, minutes
		rcall	conv_ds1302_to_tm1637
		lds		TM1637_d3, d1
		lds		TM1637_d4, d2
		rcall	TM1637_display

		rjmp	_TIM1_end

	;-------------------------- MODE 2

	_TIM1_mode_2:
		lds		BYTE, minutes
		rcall	conv_ds1302_to_tm1637
		lds		r17, d1
		eor		TM1637_d3, r17
		lds		r17, d2
		eor		TM1637_d4, r17
		lds		BYTE, hours
		rcall	conv_ds1302_to_tm1637
		lds		TM1637_d1, d1
		lds		TM1637_d2, d2
		rcall	TM1637_display

		rjmp	_TIM1_end

	;-------------------------- MODE 3

	_TIM1_mode_3:
		lds		BYTE, day
		rcall	conv_ds1302_to_tm1637
		lds		TM1637_d1, d1
		lds		TM1637_d2, d2
		lds		r17, d1
		eor		TM1637_d1, r17
		lds		r17, d2
		eor		TM1637_d2, r17
		lds		BYTE, month
		rcall	conv_ds1302_to_tm1637
		lds		TM1637_d3, d1
		lds		TM1637_d4, d2
		rcall	TM1637_display

		rjmp	_TIM1_end

	_TIM1_end:
		pop		r18
		pop		r17

	reti