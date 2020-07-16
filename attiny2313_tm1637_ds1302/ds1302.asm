;========================================================
;       Подпрограммы начала и конца передачи данных
;========================================================

DS1302_send_start:
	sbi		PORT_DS1302, CE
	nop
	ret
DS1302_send_stop:
	cbi		PORT_DS1302, CLK
	cbi		PORT_DS1302, DAT
	nop
	cbi		PORT_DS1302, CE
	nop
	ret

;========================================================
;       Отправка байта из регистра BYTE
;========================================================

DS1302_send_byte:
	push	r17
	push	BYTE

	;------------------------- Вывод DAT на выход
	sbi		DDR_DS1302, DAT
	cbi		PORT_DS1302, DAT

	;------------------------- Счётчик цикла

	ldi		r17, 0x00		

	;------------------------- Начало цикла

	while_send:
		cpi		r17, 0x08
		brsh	while_send_end

		cbi		PORT_DS1302, CLK

		lsr		BYTE			
		brcc	cbi_send_bit
			
		sbi_send_bit:
			sbi		PORT_DS1302, DAT
			rjmp	while_send_bit

		cbi_send_bit:
			cbi		PORT_DS1302, DAT

		while_send_bit:

			;------------------------- Отправка бита

			nop
			sbi		PORT_DS1302, CLK
			nop
			inc		r17

		rjmp	while_send

	;------------------------- Выход из цикла

	while_send_end:
		pop		BYTE
		pop		r17

	ret

;========================================================
;       Получение байта, результат в регистр BYTE
;========================================================

DS1302_transmit_byte:
	push	r17

	;------------------------- Вывод DAT на вход

	cbi		PORT_DS1302, DAT
	cbi		DDR_DS1302, DAT

	;------------------------- Счётчик цикла

	ldi		r17, 0x00
	ldi		BYTE, 0x00

	;------------------------- Начало цикла

	while_transmit:
		cpi		r17, 0x07
		brsh	while_transmit_end

		cbi		PORT_DS1302, CLK

		sbic	PIN_DS1302, DAT
		ori		BYTE, 0x80
		sbis	PIN_DS1302, DAT
		andi	BYTE, 0x7f

		lsr		BYTE
		nop
		sbi		PORT_DS1302, CLK
		nop

		inc		r17
		rjmp	while_transmit

	;------------------------- Выход из цикла

	while_transmit_end:
		pop		r17

	ret

;========================================================
;			Считать данные с ds1302 пакетом
;========================================================

DS1302_read_package_data:
	push	r17

	;------------------------- Минтуы

	ldi		BYTE, 0x83
	rcall	DS1302_read_package_data_f1
	sts		var_minutes, BYTE

	rcall	conv_ds1302_to_tm1637
	lds		r17, d1
	sts		tm_m1, r17

	lds		r17, d2
	sts		tm_m2, r17


	;------------------------- Часы

	ldi		BYTE, 0x85
	rcall	DS1302_read_package_data_f1
	sts		var_hours, BYTE

	rcall	conv_ds1302_to_tm1637
	lds		r17, d1
	sts		tm_h1, r17

	lds		r17, d2
	sts		tm_h2, r17


	;------------------------- Число

	ldi		BYTE, 0x87
	rcall	DS1302_read_package_data_f1
	sts		var_day, BYTE

	rcall	conv_ds1302_to_tm1637
	lds		r17, d1
	sts		tm_d1, r17

	lds		r17, d2
	sts		tm_d2, r17

	;------------------------- Месяц

	ldi		BYTE, 0x89
	rcall	DS1302_read_package_data_f1
	sts		var_month, BYTE

	rcall	conv_ds1302_to_tm1637
	lds		r17, d1
	sts		tm_mt1, r17

	lds		r17, d2
	sts		tm_mt2, r17

	;------------------------- Год

	ldi		BYTE, 0x8D
	rcall	DS1302_read_package_data_f1
	sts		var_year, BYTE

	rcall	conv_ds1302_to_tm1637
	ldi		r17, 0b01011011
	sts		tm_y1, r17
	ldi		r17, 0b00111111
	sts		tm_y2, r17

	lds		r17, d1
	sts		tm_y3, r17
	lds		r17, d2
	sts		tm_y4, r17

	pop		r17

	ret

DS1302_read_package_data_f1:
	rcall	DS1302_send_start
	rcall	DS1302_send_byte
	rcall	DS1302_transmit_byte
	rcall	DS1302_send_stop

	ret

;========================================================
;       Подпрограммы включения\отключения часов
;========================================================

DS1302_clock_on:
	rcall	DS1302_send_start
	ldi		BYTE, 0x80
	rcall	DS1302_send_byte
	ldi		BYTE, 0x00
	rcall	DS1302_send_byte
	rcall	DS1302_send_stop

	ret

DS1302_clock_off:
	rcall	DS1302_send_start
	ldi		BYTE, 0x80
	rcall	DS1302_send_byte
	ldi		BYTE, 0x80
	rcall	DS1302_send_byte
	rcall	DS1302_send_stop

	ret
