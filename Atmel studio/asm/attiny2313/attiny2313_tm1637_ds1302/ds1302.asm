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
	push	r16
	push	BYTE

	;------------------------- Вывод DAT на выход

	cbi		PORT_DS1302, DS1302_IO
	sbi		DDR_DS1302, DS1302_IO

	;------------------------- Счётчик цикла

	clr		r16

	;------------------------- Начало цикла

	DS1302_while_send:
		cpi		r16, 0x08
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

			inc		r16

		rjmp	DS1302_while_send

	;------------------------- Выход из цикла

	DS1302_while_send_end:
		pop		BYTE
		pop		r16

	ret

;========================================================
;       Получение байта, результат в регистр BYTE
;========================================================

DS1302_receive_byte:
	push	r16

	;------------------------- Вывод DAT на вход

	cbi		PORT_DS1302, DS1302_IO
	cbi		DDR_DS1302, DS1302_IO

	;------------------------- Счётчик цикла

	clr		r16
	clr		BYTE

	;------------------------- Начало цикла

	DS1302_while_receive:
		cpi		r16, 0x07
		brsh	DS1302_while_receive_end

		rcall	DS1302_receive_byte_write_bit

		lsr		BYTE
		sbi		PORT_DS1302, DS1302_SCLK
		rcall	MCU_wait_10mks

		inc		r16
		rjmp	DS1302_while_receive

	;------------------------- Выход из цикла и получение последнего бита

	DS1302_while_receive_end:
		rcall	DS1302_receive_byte_write_bit
		sbi		PORT_DS1302, DS1302_SCLK

		pop		r16

	ret

DS1302_receive_byte_write_bit:
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
	push	r16
	push	r15
	push	XH
	push	XL
	push	YH
	push	YL

	ldi		XH, high(bcd_seconds)
	ldi		XL, low(bcd_seconds)

	ldi		YH, high(tm_s1)
	ldi		YL, low(tm_s1)

	rcall	DS1302_send_start
	ldi		BYTE, 0xBF
	rcall	DS1302_send_byte

	clr		r17

	DS1302_read_package_data_while_receive:
		cpi		r17, 0x07
		brsh	DS1302_read_package_data_while_receive_end

		rcall	DS1302_receive_byte

		st		X+, BYTE
		push	r17
		mov		r17, BYTE
		rcall	conv_ds1302_to_tm1637
		st		Y+, r16
		st		Y+, r15
		pop		r17

		inc		r17

		rjmp	DS1302_read_package_data_while_receive

	DS1302_read_package_data_while_receive_end:

		rcall	DS1302_send_stop

		pop		YL
		pop		YH
		pop		XL
		pop		XH
		pop		r15
		pop		r16
		pop		r17

	ret