;========================================================
;       Подпрограммы начала и конца передачи данных
;========================================================

DS1302_send_start:
	sbi		PORT_DS1302, DS1302_CE
	rcall	MCU_wait_10mks

	ret

DS1302_send_stop:
	cbi		PORT_DS1302, DS1302_SCLK
	cbi		PORT_DS1302, DS1302_IO
	cbi		PORT_DS1302, DS1302_CE

	rcall	MCU_wait_10mks

	ret

;========================================================
;       Отправка байта из регистра BYTE
;========================================================

DS1302_send_byte:
	push	r17
	push	BYTE

	;------------------------- Вывод DAT на выход

	sbi		DDR_DS1302, DS1302_IO
	cbi		PORT_DS1302, DS1302_IO

	;------------------------- Счётчик цикла

	clr		r17

	;------------------------- Начало цикла

	DS1302_while_send:
		cpi		r17, 0x08
		brsh	DS1302_while_send_end

		cbi		PORT_DS1302, DS1302_SCLK
		rcall	MCU_wait_10mks

		lsr		BYTE			
		brcc	DS1302_cbi_send_bit
			
		DS1302_sbi_send_bit:
			sbi		PORT_DS1302, DS1302_IO
			rjmp	DS1302_while_send_bit

		DS1302_cbi_send_bit:
			cbi		PORT_DS1302, DS1302_IO

		DS1302_while_send_bit:

			;------------------------- Отправка бита

			sbi		PORT_DS1302, DS1302_SCLK
			rcall	MCU_wait_10mks

			inc		r17

		rjmp	DS1302_while_send

	;------------------------- Выход из цикла

	DS1302_while_send_end:
		pop		BYTE
		pop		r17

	ret

;========================================================
;       Получение байта, результат в регистр BYTE
;========================================================

DS1302_transmit_byte:
	push	r17

	;------------------------- Вывод DAT на вход

	cbi		PORT_DS1302, DS1302_IO
	cbi		DDR_DS1302, DS1302_IO

	;------------------------- Счётчик цикла

	clr		r17
	clr		BYTE

	;------------------------- Начало цикла

	DS1302_while_transmit:
		cpi		r17, 0x07
		brsh	DS1302_while_transmit_end

		rcall	DS1302_transmit_byte_write_bit

		lsr		BYTE
		sbi		PORT_DS1302, DS1302_SCLK
		rcall	MCU_wait_10mks

		inc		r17
		rjmp	DS1302_while_transmit

	;------------------------- Выход из цикла

	DS1302_while_transmit_end:
		rcall	DS1302_transmit_byte_write_bit
		pop		r17

	ret

DS1302_transmit_byte_write_bit:
	cbi		PORT_DS1302, DS1302_SCLK
	rcall	MCU_wait_10mks
	sbic	PIN_DS1302, DS1302_IO
	ori		BYTE, 0x80
	sbis	PIN_DS1302, DS1302_IO
	andi	BYTE, 0x7f

	ret
;========================================================
;			Считать данные с ds1302 пакетом
;========================================================

DS1302_read_package_data:
	push	r17
	push	ZH
	push	ZL
	push	YH
	push	YL
	push	XH
	push	XL

	;------------------------- Минтуы

	ldi		BYTE, 0x83
	ldi		XH, high(bcd_minutes)		
	ldi		XL, low(bcd_minutes)
	ldi		YH, high(tm_m1)		
	ldi		YL, low(tm_m1)
	ldi		ZH, high(tm_m2)		
	ldi		ZL, low(tm_m2)

	rcall	DS1302_read_package_data_ext

	;------------------------- Часы

	ldi		BYTE, 0x85
	ldi		XH, high(bcd_hours)		
	ldi		XL, low(bcd_hours)
	ldi		YH, high(tm_h1)		
	ldi		YL, low(tm_h1)
	ldi		ZH, high(tm_h2)		
	ldi		ZL, low(tm_h2)

	rcall	DS1302_read_package_data_ext

	;------------------------- Число

	ldi		BYTE, 0x87
	ldi		XH, high(bcd_day)		
	ldi		XL, low(bcd_day)
	ldi		YH, high(tm_d1)		
	ldi		YL, low(tm_d1)
	ldi		ZH, high(tm_d2)		
	ldi		ZL, low(tm_d2)

	rcall	DS1302_read_package_data_ext

	;------------------------- Месяц

	ldi		BYTE, 0x89
	ldi		XH, high(bcd_month)		
	ldi		XL, low(bcd_month)
	ldi		YH, high(tm_mt1)		
	ldi		YL, low(tm_mt1)
	ldi		ZH, high(tm_mt2)		
	ldi		ZL, low(tm_mt2)

	rcall	DS1302_read_package_data_ext

	;------------------------- Год

	ldi		BYTE, 0x8D
	ldi		XH, high(bcd_year)		
	ldi		XL, low(bcd_year)
	ldi		YH, high(tm_y3)		
	ldi		YL, low(tm_y3)
	ldi		ZH, high(tm_y4)		
	ldi		ZL, low(tm_y4)

	rcall	DS1302_read_package_data_ext

	pop		XL
	pop		XH
	pop		YL
	pop		YH
	pop		ZL
	pop		ZH
	pop		r17

	ret

DS1302_read_package_data_f1:
	rcall	DS1302_send_start
	rcall	DS1302_send_byte
	rcall	DS1302_transmit_byte
	rcall	DS1302_send_stop

	ret

;========================================================
;			Считать данные с ds1302.
;	Адрес регистра чтения ds1302 в регистре BYTE.
;	Запись ответа от ds1302 в переменную по адресу X.
;	Запись преобразованных ответов для TM1367 в 
;	переменные по адресу Y (старший разряд) 
;	и Z (младший разряд).
;========================================================

DS1302_read_package_data_ext:
	rcall	DS1302_read_package_data_f1
	st		X, BYTE

	rcall	conv_ds1302_to_tm1637
	st		Y, r16

	st		Z, r15

	ret

/*;========================================================
;       Подпрограммы включения\отключения часов
;		входящее значение - r18
;========================================================

DS1302_clock_change_state:
	rcall	DS1302_send_start
	ldi		BYTE, 0x80
	rcall	DS1302_send_byte
	mov		BYTE, r18
	rcall	DS1302_send_byte
	rcall	DS1302_send_stop

	ret*/