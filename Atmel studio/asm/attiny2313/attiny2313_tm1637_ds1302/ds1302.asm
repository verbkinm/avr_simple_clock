;========================================================
;       ������������ ������ � ����� �������� ������
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
;       �������� ����� �� �������� BYTE
;========================================================

DS1302_send_byte:
	push	r16
	push	BYTE

	;------------------------- ����� DAT �� �����

	cbi		PORT_DS1302, DS1302_IO
	sbi		DDR_DS1302, DS1302_IO

	;------------------------- ������� �����

	clr		r16

	;------------------------- ������ �����

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

			;------------------------- �������� ����

			sbi		PORT_DS1302, DS1302_SCLK
			rcall	MCU_wait_10mks

			inc		r16

		rjmp	DS1302_while_send

	;------------------------- ����� �� �����

	DS1302_while_send_end:
		pop		BYTE
		pop		r16

	ret

;========================================================
;       ��������� �����, ��������� � ������� BYTE
;========================================================

DS1302_receive_byte:
	push	r16

	;------------------------- ����� DAT �� ����

	cbi		PORT_DS1302, DS1302_IO
	cbi		DDR_DS1302, DS1302_IO

	;------------------------- ������� �����

	clr		r16
	clr		BYTE

	;------------------------- ������ �����

	DS1302_while_receive:
		cpi		r16, 0x07
		brsh	DS1302_while_receive_end

		rcall	DS1302_receive_byte_write_bit

		lsr		BYTE
		sbi		PORT_DS1302, DS1302_SCLK
		rcall	MCU_wait_10mks

		inc		r16
		rjmp	DS1302_while_receive

	;------------------------- ����� �� ����� � ��������� ���������� ����

	DS1302_while_receive_end:
		rcall	DS1302_receive_byte_write_bit
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
;			������� ������ � ds1302 �������
;========================================================

DS1302_read_package_data:
	push	r17
	push	ZH
	push	ZL
	push	YH
	push	YL
	push	XH
	push	XL

	;------------------------- ������

	ldi		BYTE, 0x83
	ldi		XH, high(bcd_minutes)		
	ldi		XL, low(bcd_minutes)
	ldi		YH, high(tm_m1)		
	ldi		YL, low(tm_m1)
	ldi		ZH, high(tm_m2)		
	ldi		ZL, low(tm_m2)

	rcall	DS1302_read_package_data_ext

	;------------------------- ����

	ldi		BYTE, 0x85
	ldi		XH, high(bcd_hours)		
	ldi		XL, low(bcd_hours)
	ldi		YH, high(tm_h1)		
	ldi		YL, low(tm_h1)
	ldi		ZH, high(tm_h2)		
	ldi		ZL, low(tm_h2)

	rcall	DS1302_read_package_data_ext

	;------------------------- �����

	ldi		BYTE, 0x87
	ldi		XH, high(bcd_day)		
	ldi		XL, low(bcd_day)
	ldi		YH, high(tm_d1)		
	ldi		YL, low(tm_d1)
	ldi		ZH, high(tm_d2)		
	ldi		ZL, low(tm_d2)

	rcall	DS1302_read_package_data_ext

	;------------------------- �����

	ldi		BYTE, 0x89
	ldi		XH, high(bcd_month)		
	ldi		XL, low(bcd_month)
	ldi		YH, high(tm_mt1)		
	ldi		YL, low(tm_mt1)
	ldi		ZH, high(tm_mt2)		
	ldi		ZL, low(tm_mt2)

	rcall	DS1302_read_package_data_ext

	;------------------------- ���

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

;========================================================
;			������� ������ � ds1302.
;	����� �������� ������ ds1302 � �������� BYTE.
;	������ ������ �� ds1302 � ���������� �� ������ X.
;	������ ��������������� ������� ��� TM1367 � 
;	���������� �� ������ Y (������� ������) 
;	� Z (������� ������).
;========================================================

DS1302_read_package_data_ext:
	rcall	DS1302_send_start
	rcall	DS1302_send_byte
	rcall	DS1302_receive_byte
	rcall	DS1302_send_stop

	st		X, BYTE
	mov		r17, BYTE
	rcall	conv_ds1302_to_tm1637
	st		Y, r16
	st		Z, r15

	ret
