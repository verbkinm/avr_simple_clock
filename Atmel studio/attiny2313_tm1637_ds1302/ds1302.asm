;========================================================
;       ������������ ������ � ����� �������� ������
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
;       �������� ����� �� �������� BYTE
;========================================================

DS1302_send_byte:
	push	r17
	push	BYTE

	;------------------------- ����� DAT �� �����

	sbi		DDR_DS1302, DAT
	cbi		PORT_DS1302, DAT

	;------------------------- ������� �����

	ldi		r17, 0x00		

	;------------------------- ������ �����

	DS1302_while_send:
		cpi		r17, 0x08
		brsh	DS1302_while_send_end

		cbi		PORT_DS1302, CLK

		lsr		BYTE			
		brcc	DS1302_cbi_send_bit
			
		DS1302_sbi_send_bit:
			sbi		PORT_DS1302, DAT
			rjmp	DS1302_while_send_bit

		DS1302_cbi_send_bit:
			cbi		PORT_DS1302, DAT

		DS1302_while_send_bit:

			;------------------------- �������� ����

			nop
			sbi		PORT_DS1302, CLK
			nop
			inc		r17

		rjmp	DS1302_while_send

	;------------------------- ����� �� �����

	DS1302_while_send_end:
		pop		BYTE
		pop		r17

	ret

;========================================================
;       ��������� �����, ��������� � ������� BYTE
;========================================================

DS1302_transmit_byte:
	push	r17

	;------------------------- ����� DAT �� ����

	cbi		PORT_DS1302, DAT
	cbi		DDR_DS1302, DAT

	;------------------------- ������� �����

	ldi		r17, 0x00
	ldi		BYTE, 0x00

	;------------------------- ������ �����

	DS1302_while_transmit:
		cpi		r17, 0x07
		brsh	DS1302_while_transmit_end

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
		rjmp	DS1302_while_transmit

	;------------------------- ����� �� �����

	DS1302_while_transmit_end:
		pop		r17

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
	ldi		XH, high(var_minutes)		
	ldi		XL, low(var_minutes)
	ldi		YH, high(tm_m1)		
	ldi		YL, low(tm_m1)
	ldi		ZH, high(tm_m2)		
	ldi		ZL, low(tm_m2)

	rcall	DS1302_read_package_data_ext


	;------------------------- ����

	ldi		BYTE, 0x85
	ldi		XH, high(var_hours)		
	ldi		XL, low(var_hours)
	ldi		YH, high(tm_h1)		
	ldi		YL, low(tm_h1)
	ldi		ZH, high(tm_h2)		
	ldi		ZL, low(tm_h2)

	rcall	DS1302_read_package_data_ext

	;------------------------- �����

	ldi		BYTE, 0x87
	ldi		XH, high(var_day)		
	ldi		XL, low(var_day)
	ldi		YH, high(tm_d1)		
	ldi		YL, low(tm_d1)
	ldi		ZH, high(tm_d2)		
	ldi		ZL, low(tm_d2)

	rcall	DS1302_read_package_data_ext

	;------------------------- �����

	ldi		BYTE, 0x89
	ldi		XH, high(var_month)		
	ldi		XL, low(var_month)
	ldi		YH, high(tm_mt1)		
	ldi		YL, low(tm_mt1)
	ldi		ZH, high(tm_mt2)		
	ldi		ZL, low(tm_mt2)

	rcall	DS1302_read_package_data_ext

	;------------------------- ���

	ldi		BYTE, 0x8D
	ldi		XH, high(var_year)		
	ldi		XL, low(var_year)
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
;			������� ������ � ds1302.
;	������ �������� ������ ds1302 � �������� BYTE.
;	������ ������ �� ds1302 � ���������� �� ������ X.
;	������ ��������������� ������� ��� TM1367 � 
;	���������� �� ������ Y (������� ������) 
;	� Z (������� ������).
;========================================================

DS1302_read_package_data_ext:
	rcall	DS1302_read_package_data_f1
	st		X, BYTE

	rcall	conv_ds1302_to_tm1637
	lds		r17, d1
	st		Y, r17

	lds		r17, d2
	st		Z, r17

	ret

;========================================================
;       ������������ ���������\���������� �����
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
