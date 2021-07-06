;========================================================
;		Преобразование данных с ds1302 в 
;		числа для 4-х сегментного дисплея tm1637
;		запись результата в регистры r16:r15 
;		вход - регистр r17
;		выход - r16:r15
;========================================================

conv_ds1302_to_tm1637:
	push	r17

	;------------------------- преобразуем младший разряд в регистр r15

	mov		r18, r17
	andi	r18, 0x0f
	rcall	bin_to_tm1637_digit
	mov		r15, r18

	;------------------------- преобразуем старший разряд в регистр r16

	mov		r18, r17
	andi	r18, 0xf0
	swap	r18
	rcall	bin_to_tm1637_digit
	mov		r16, r18

	pop		r17

	ret

;========================================================
;	Подфункция преобразования.
;   Данные из регистра r18 преобразуются в числовое 
;	значение для 7-сегментного индикатора, результат в 
;	регистр r18
;========================================================

bin_to_tm1637_digit:
	cpi		r18, 0x00
	breq	_d0
	cpi		r18, 0x01
	breq	_d1
	cpi		r18, 0x02
	breq	_d2
	cpi		r18, 0x03
	breq	_d3
	cpi		r18, 0x04
	breq	_d4
	cpi		r18, 0x05
	breq	_d5
	cpi		r18, 0x06
	breq	_d6
	cpi		r18, 0x07
	breq	_d7
	cpi		r18, 0x08
	breq	_d8
	cpi		r18, 0x09
	breq	_d9

	rjmp	_dx

	;------------------------- Подпрограммы для чисел 0..9

	_d0:
		ldi		r18, char_0
		rjmp	bin_to_tm1637_digit_end
	_d1:
		ldi		r18, char_1
		rjmp	bin_to_tm1637_digit_end
	_d2:
		ldi		r18, char_2
		rjmp	bin_to_tm1637_digit_end
	_d3:
		ldi		r18, char_3
		rjmp	bin_to_tm1637_digit_end
	_d4:
		ldi		r18, char_4
		rjmp	bin_to_tm1637_digit_end
	_d5:
		ldi		r18, char_5
		rjmp	bin_to_tm1637_digit_end
	_d6:
		ldi		r18, char_6
		rjmp	bin_to_tm1637_digit_end
	_d7:
		ldi		r18, char_7
		rjmp	bin_to_tm1637_digit_end
	_d8:
		ldi		r18, char_8
		rjmp	bin_to_tm1637_digit_end
	_d9:
		ldi		r18, char_9
		rjmp	bin_to_tm1637_digit_end
	_dx:
		ldi		r18, char_3_dash
	
	bin_to_tm1637_digit_end:

	ret

;========================================================
;	Подпрограммы инкремента с установленными границами
;	входящее\исходящее значение == r17, r19 == min, r18 == max + 1
;========================================================

_inc:
	inc		r17
	cp		r17, r18
	brsh	_inc_reset

	rjmp	_inc_end

	_inc_reset:
		mov		r17, r19

	_inc_end:
	
		ret
;========================================================
;	Подпрограммы инкремента с установленными границами
;	и вызовом подпрограммы
;========================================================

inc_circle:
	push	r18
	push	r19
	push	XL
	push	XH
	push	ZL
	push	ZH

	mov		r19, CONST_ZERO
	
	;-------------------------- Выбор режима mode

	cpi		mode, mode_1
	breq	inc_circle_hour

	cpi		mode, mode_2
	breq	inc_circle_minutes

	cpi		mode, mode_3
	breq	inc_circle_day

	cpi		mode, mode_4
	breq	inc_circle_month

	cpi		mode, mode_5
	breq	inc_circle_year

	cpi		mode, mode_6
	breq	rcall_inc_cicle_alarm

	cpi		mode, mode_7
	breq	rcall_inc_cicle_alarm

	cpi		mode, mode_8
	breq	rcall_inc_cicle_alarm

	cpi		mode, mode_9
	breq	rcall_inc_cicle_light

	rjmp	inc_circle_end

	;-------------------------- Часы

	inc_circle_hour:
		ldi		XH, high(bcd_hours)		
		ldi		XL, low(bcd_hours)
		ldi		r18, 24
		ldi		BYTE, 0x84
		ldi		ZH, high(TM1637_display_time)
		ldi		ZL, low(TM1637_display_time)

		rcall	inc_circle_ext

		rjmp	inc_circle_end

	;-------------------------- Минуты

	inc_circle_minutes:
		ldi		XH, high(bcd_minutes)		
		ldi		XL, low(bcd_minutes)
		ldi		r18, 60
		ldi		BYTE, 0x82
		ldi		ZH, high(TM1637_display_time)
		ldi		ZL, low(TM1637_display_time)

		rcall	inc_circle_ext

		rjmp	inc_circle_end

	;-------------------------- День месяца

	inc_circle_day:
		ldi		XH, high(bcd_day)		
		ldi		XL, low(bcd_day)
		ldi		r19, 1
		rcall	get_max_day
		inc		r17
		mov		r18, r17
		ldi		BYTE, 0x86
		ldi		ZH, high(TM1637_display_date)
		ldi		ZL, low(TM1637_display_date)

		rcall	inc_circle_ext

		rjmp	inc_circle_end

	;-------------------------- Месяц

	inc_circle_month:
		ldi		XH, high(bcd_month)		
		ldi		XL, low(bcd_month)
		ldi		r19, 1
		ldi		r18, 13
		ldi		BYTE, 0x88
		ldi		ZH, high(TM1637_display_date)
		ldi		ZL, low(TM1637_display_date)

		rcall	inc_circle_ext

		rjmp	inc_circle_end

	;-------------------------- Год

	inc_circle_year:
		ldi		XH, high(bcd_year)		
		ldi		XL, low(bcd_year)
		ldi		r18, 100
		ldi		BYTE, 0x8C
		ldi		ZH, high(TM1637_display_year)
		ldi		ZL, low(TM1637_display_year)

		rcall	inc_circle_ext

		rjmp	inc_circle_end

	;-------------------------- Будильник

	rcall_inc_cicle_alarm:
		rcall	inc_cicle_alarm

		rjmp	inc_circle_end

	;-------------------------- Яркость дисплея

	rcall_inc_cicle_light:
		ldi		r17, light
		rcall	EEPROM_read
		ldi		r19, 0x00
		ldi		r18, 0x08
		rcall	_inc
		
		ldi		r18, light
		rcall	EEPROM_write

		mov		r18, r17
		rcall	bin_to_tm1637_digit
		sts		tm_light, r18

		mov		BYTE, r17
		rcall	TM1637_set_ligth
		rcall	TM1637_display_light

	;-------------------------- Конец инкрементации
			
	inc_circle_end:
		pop		ZH
		pop		ZL
		pop		XH
		pop		XL
		pop		r19
		pop		r18

	ret

;========================================================
;		Преобразование 8-битного двоичного
;		значения в упакованный BCD формат
;		Входящее\исходящее значение == r17
;========================================================

bin8bcd:
	push	r18
	push	r16

	.def	digitL	=	r18
	.def	digitH	=	r16

	mov		digitL, r17
	clr		digitH

	bin8bcd_loop:
		subi	digitL, 0x0a
		brmi	bin8bcd_end

		inc		digitH
		rjmp	bin8bcd_loop

	bin8bcd_end:
		subi	digitL, -0x0a

		swap	digitH
		mov		r17, digitH

		andi	digitL, 0x0f
		or		r17, digitL

		.undef	digitL
		.undef	digitH

		pop		r19
		pop		r16

	ret

;========================================================
;		Преобразование 8-битного упакованного
;		значения в двоичный формат
;		Входящее\исходящее значение == r17
;========================================================

bcd8bin:
	push	r18

	.def	result	=	r17
	.def	tens	=	r18

	mov		tens, r17
	andi	tens, 0xf0
	swap	tens

	andi	result, 0x0f
	
	bcd8bind_loop:
		dec		tens
		brmi	bcd8bin_end

		subi	result, -0x0a
		rjmp	bcd8bind_loop

	bcd8bin_end:
		.undef	result
		.undef	tens

		pop		r18

	ret

;========================================================
;	Инкремент переменной по адресу X.
;	Верхняя граница - max_digit (r18).
;	Нижняя граница - min_digit (r19).
;	Адрес регистра для DS1302 в регистре BYTE.
;	Непрямой вызов подпрограммы по адресу Z
;========================================================

inc_circle_ext:
	push	r17

	ld		r17, X
	rcall	bcd8bin
	inc		r17

	cp		r17,  r18
	brsh	inc_circle_ext_reset

	rjmp	inc_circle_ext_end

	inc_circle_ext_reset:
		mov		r17, r19

	inc_circle_ext_end:
		rcall	DS1302_send_start
		rcall	DS1302_send_byte

		rcall	bin8bcd
		mov		BYTE, r17

		rcall	DS1302_send_byte
		rcall	DS1302_send_stop	

		rcall	DS1302_read_package_data
		icall

		pop		r17

	ret

;========================================================
;	Нахождение максимального дня текущего месяца
;	с учётом високосных лет
;	Исходящее значение == r17
;========================================================

get_max_day:
	push	ZH
	push	ZL
	push	YH
	push	YL

	ldi		ZH, high(max_day_in_month*2)
	ldi		ZL, low(max_day_in_month*2)

	lds		r17, bcd_month
	rcall	bcd8bin
	dec		r17

	ldi		YH, 0
	mov		YL, r17

	add		ZL, YL
	adc		ZH, YH
	lpm		r17, Z

	rcall	leap_year

	pop		YL
	pop		YH
	pop		ZL
	pop		ZH

	ret

;========================================================
;	Определение високосного года и перезапись 
;	Если год високосный и сейчас 2-й месяц,
;	меняется значение r17 = 29
;========================================================

leap_year:
	push	r16

	;------------------------- Сохраняем значение r17 в r16, чтобы его не изменить в случае, 
	;------------------------- если сейчас не февраль високосного года

	mov		r16, r17

	;------------------------- Если установлен не февраль, проверка на високосный год не нужна

	lds		r17, bcd_month
	cpi		r17, 0x02
	brne	leap_year_end

	;------------------------- Каждый сотый год не високосный. В нашем случая, только нулевой год

	lds		r17, bcd_year
	cpi		r17, 0x00
	breq	leap_year_end

	;------------------------- Если один из двух младших битов или оба установлены
	;------------------------- число не кратно 4-м. Год високосный

	rcall	bcd8bin
	sbrc	r17, 1
	rjmp	leap_year_end
	sbrc	r17, 0
	rjmp	leap_year_end

	;------------------------- Максимальное значение числа месяца = 29

	ldi		r16, 29
		
	leap_year_end:
		mov		r17, r16
		pop		r16

	ret

;========================================================
;		Смена режима TIM0
;========================================================

change_tim0_off:
	push	r17

	out		TCCR0A, CONST_ZERO
	out		TCCR0B, CONST_ZERO
	out		OCR0A, CONST_ZERO

	pop		r17

	ret

;========================================================
;		Смена режима TIM0
;========================================================

change_tim0_to_buzzer_mode:
	push	r17

	ldi		r17, (1 << WGM01) | (0 << COM0A1) | (1 << COM0A0)		
	out		TCCR0A, r17
	ldi		r17, (0 << CS02) | (1 << CS01) | (0 << CS00) 
	out		TCCR0B, r17
	ldi		r17, kdel4
	out		OCR0A, r17

	pop		r17

	ret

;========================================================
;			 Запись в EEPROM память
;	адрес - r18
;	данные для записи - r17
;========================================================

EEPROM_write:
	push	r17
	push	r18

	sbic	EECR, EEPE
	rjmp	EEPROM_write
	out		EECR, CONST_ZERO
	out		EEARL, r18
	out		EEDR, r17
	sbi		EECR, EEMPE
	sbi		EECR, EEPE

	pop		r18
	pop		r17

	ret

;========================================================
;			 Чтение из EEPROM памяти
;	адрес - r17
;	возвращаемые данные - r17
;========================================================

EEPROM_read:
	sbic	EECR, EEPE
	rjmp	EEPROM_read
	out		EEARL, r17
	sbi		EECR, EERE
	in		r17, EEDR

	ret
