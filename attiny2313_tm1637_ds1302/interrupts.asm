;========================================================
;       Подпрограммы обработки прерываний
;========================================================

;-------------------------- Прерывание при нажатии кнопки MODE

_INT0:

		reti

;-------------------------- Прерывание при нажатии кнопки SET

_INT1:
		push	r17

		ldi		r17, 0x00
		out		TCCR1B, r17 ; выключить таймер

		rcall	TM1637_display_dash

		lds		r17, clock_mode
		inc		r17

		cpi		r17, 0x03
		brsh	reset_clock_mode
		rjmp	_INT1_1

reset_clock_mode:
		ldi		r17, 0x00

_INT1_1:
		sts		clock_mode, r17

		ldi		r17, (1 << WGM12) | (1 << CS12) | (0 << CS11) | (1 << CS10) ; Выбор режима таймера (СТС, предделитель = 1024) 
		out		TCCR1B, r17
		ldi		r17, high(kdel0)
		out		TCNT1H, r17
		ldi		r17, low(kdel0)
		out		TCNT1L, r17

		pop		r17
		reti
	
;-------------------------- Прерывание таймера T1	

_TIM1:	
		lds		r17, clock_mode

		cpi		r17, 0x00
		breq	time_mode

		cpi		r17, 0x01
		breq	date_mode

		cpi		r17, 0x02
		breq	year_mode

time_mode:
		ldi		r17, 0x85
		ldi		r18, 0x83
		rjmp	_TIM1_prepare_display

date_mode:
		ldi		r17, 0x87
		ldi		r18, 0x89
		rjmp	_TIM1_prepare_display

year_mode:
		ldi		r18, 0x8D

_TIM1_prepare_display:
		rcall	prepare_display

;-------------------------- Вывести результат на дисплей tm1637

		rcall	TM1637_display
		reti

;-------------------------- Прерывание таймера T0	

_TIM0:
		ldi		r17, 0x00
		out		TCCR0B, r17 ; выключить таймер
		reti