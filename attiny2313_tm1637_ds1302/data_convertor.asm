;========================================================
;		Преобразование данных с ds1302 в 
;		числа для 4-х сегментного дисплея tm1637
;		запись результата в переменные d1 и d2
;		вход - регистр BYTE
;========================================================

conv_ds1302_to_tm1637:
	push	r17

	;------------------------- преобразуем младший разряд в переменную d2

	mov		r17, BYTE
	andi	r17, 0x0f
	rcall	bin_to_tm1637_digit
	lds		r17, d1
	sts		d2, r17

	;------------------------- преобразуем старший разряд в переменную d1

	mov		r17, BYTE
	andi	r17, 0x70
	lsr		r17
	lsr		r17
	lsr		r17
	lsr		r17
	rcall	bin_to_tm1637_digit
	pop		r17

	ret

;------------------------- Подфункция преобразования.
;------------------------- Данные из регистра r17 преобразуются в числовое 
;------------------------- значение для 7-сегментного индикатора, результат в 
;------------------------- переменную d1

bin_to_tm1637_digit:
	push	r17

	cpi		r17, 0x00
	breq	_d0
	cpi		r17, 0x01
	breq	_d1
	cpi		r17, 0x02
	breq	_d2
	cpi		r17, 0x03
	breq	_d3
	cpi		r17, 0x04
	breq	_d4
	cpi		r17, 0x05
	breq	_d5
	cpi		r17, 0x06
	breq	_d6
	cpi		r17, 0x07
	breq	_d7
	cpi		r17, 0x08
	breq	_d8
	cpi		r17, 0x09
	breq	_d9

	rjmp	_dx

	;------------------------- Подпрограммы для чисел 0..9

	_d0:
		ldi		r17, 0b00111111
		sts		d1, r17
		rjmp	bin_to_tm1637_digit_end
	_d1:
		ldi		r17, 0b00000110
		sts		d1, r17
		rjmp	bin_to_tm1637_digit_end
	_d2:
		ldi		r17, 0b01011011
		sts		d1, r17
		rjmp	bin_to_tm1637_digit_end
	_d3:
		ldi		r17, 0b01001111
		sts		d1, r17
		rjmp	bin_to_tm1637_digit_end
	_d4:
		ldi		r17, 0b01100110
		sts		d1, r17
		rjmp	bin_to_tm1637_digit_end
	_d5:
		ldi		r17, 0b01101101
		sts		d1, r17
		rjmp	bin_to_tm1637_digit_end
	_d6:
		ldi		r17, 0b01111101
		sts		d1, r17
		rjmp	bin_to_tm1637_digit_end
	_d7:
		ldi		r17, 0b00000111
		sts		d1, r17
		rjmp	bin_to_tm1637_digit_end
	_d8:
		ldi		r17, 0b01111111
		sts		d1, r17
		rjmp	bin_to_tm1637_digit_end
	_d9:
		ldi		r17, 0b01101111
		sts		d1, r17
		rjmp	bin_to_tm1637_digit_end
	_dx:
		ldi		r17, 0b01001001
		sts		d1, r17
	
	bin_to_tm1637_digit_end:
		pop		r17

	ret

;========================================================
;	Подпрограммы инкремента до определённого порога
;========================================================
inc_circle:
	push	r17
	push	r18
	push	r19

	lds		r17, mode

	;-------------------------- Выбор режима mode

	cpi		r17, 0x01
	breq	inc_circle_hour

	cpi		r17, 0x02
	breq	inc_circle_minutes

	cpi		r17, 0x03
	breq	inc_circle_day

	cpi		r17, 0x04
	breq	inc_circle_month

	cpi		r17, 0x05
	breq	inc_circle_year

	rjmp	inc_circle_end

	;-------------------------- Часы

	inc_circle_hour:
		ldi		XH, high(var_hours)		
		ldi		XL, low(var_hours)
		ldi		r19, 0
		ldi		r18, 24
		ldi		BYTE, 0x84
		ldi		ZH, high(TM1637_display_time)
		ldi		ZL, low(TM1637_display_time)

		rcall	inc_circle_ext

		rjmp	inc_circle_end

	;-------------------------- Минуты

	inc_circle_minutes:
		ldi		XH, high(var_minutes)		
		ldi		XL, low(var_minutes)
		ldi		r19, 0
		ldi		r18, 60
		ldi		BYTE, 0x82
		ldi		ZH, high(TM1637_display_time)
		ldi		ZL, low(TM1637_display_time)

		rcall	inc_circle_ext

		rjmp	inc_circle_end

	;-------------------------- День месяца

	inc_circle_day:
		ldi		XH, high(var_day)		
		ldi		XL, low(var_day)
		ldi		r19, 1
		ldi		r18, 32
		ldi		BYTE, 0x86
		ldi		ZH, high(TM1637_display_date)
		ldi		ZL, low(TM1637_display_date)

		rcall	inc_circle_ext

		rjmp	inc_circle_end

	;-------------------------- Месяц

	inc_circle_month:
		ldi		XH, high(var_month)		
		ldi		XL, low(var_month)
		ldi		r19, 1
		ldi		r18, 13
		ldi		BYTE, 0x88
		ldi		ZH, high(TM1637_display_date)
		ldi		ZL, low(TM1637_display_date)

		rcall	inc_circle_ext

		rjmp	inc_circle_end

	;-------------------------- Год

	inc_circle_year:
		ldi		XH, high(var_year)		
		ldi		XL, low(var_year)
		ldi		r18, 100
		ldi		BYTE, 0x8C
		ldi		ZH, high(TM1637_display_year)
		ldi		ZL, low(TM1637_display_year)

		rcall	inc_circle_ext

	;-------------------------- Конец инкрементации
			
	inc_circle_end:
		pop		r19
		pop		r18
		pop		r17

	ret

;========================================================
;		Преобразование 8-битного двоичного
;		значения в упакованный BCD формат
;		Входящее\исходящее значение == BYTE
;========================================================

bin8bcd:
	push	r18
	push	r19

	.def	digitL	=	r18
	.def	digitH	=	r19

	mov		digitL, BYTE
	ldi		digitH, 0x00

	bin8bcd_loop:
		subi	digitL, 0x0a
		brmi	bin8bcd_end

		inc		digitH
		rjmp	bin8bcd_loop

	bin8bcd_end:
		subi	digitL, -0x0a

		swap	digitH
		mov		BYTE, digitH

		andi	digitL, 0x0f
		or		BYTE, digitL

		.undef	digitL
		.undef	digitH

		pop		r19
		pop		r18

	ret

;========================================================
;		Преобразование 8-битного упаковонного
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

	.def	max_digit = r18
	.def	min_digit = r19

	ld		r17, X
	rcall	bcd8bin
	inc		r17

	cp		r17,  max_digit
	brsh	inc_circle_ext_reset

	rjmp	inc_circle_ext_end

	inc_circle_ext_reset:
		mov		r17, min_digit

	inc_circle_ext_end:
		rcall	DS1302_send_start

		rcall	DS1302_send_byte

		mov		BYTE, r17
		rcall	bin8bcd

		rcall	DS1302_send_byte

		rcall	DS1302_send_stop	

		rcall	DS1302_read_package_data
		icall

		.undef	max_digit
		.undef	min_digit

		pop		r17

	ret