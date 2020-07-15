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
;       �������� �����
;========================================================

DS1302_send_byte:
	push	r18
	push	r17
	push	r16

	;------------------------- ����� DAT �� �����
	sbi		DDR_DS1302, DAT
	cbi		PORT_DS1302, DAT

	;------------------------- ������� �����

	ldi		r17, 0x00		

	;------------------------- ������ �����

	while_send:
		cpi		r17, 0x08
		brsh	while_send_end

		cbi		PORT_DS1302, CLK

		lsr		BYTE			; ���������� ��������� ���,
		ldi		r18, 0x00		; ������� � �������� �,
		ldi		r16, 0x00		; c ����� (BYTE) � ����
		cpc		r16, r18		;
		brcc	cbi_send_bit
			
		sbi_send_bit:
			sbi		PORT_DS1302, DAT
			rjmp	while_send_bit

		cbi_send_bit:
			cbi		PORT_DS1302, DAT

		while_send_bit:

			;------------------------- �������� ����

			nop
			sbi		PORT_DS1302, CLK
			nop
			inc		r17

		rjmp	while_send

	;------------------------- ����� �� �����

	while_send_end:
		pop		r16
		pop		r17
		pop		r18

	ret

;========================================================
;       ��������� �����
;========================================================

DS1302_transmit_byte:
	push	r18
	push	r17

	;------------------------- ����� DAT �� ����

	cbi		PORT_DS1302, DAT
	cbi		DDR_DS1302, DAT

	;------------------------- ������� �����

	ldi		r17, 0x00
	ldi		BYTE, 0x00

	;------------------------- ������ �����

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

	;------------------------- ����� �� �����

	while_transmit_end:
		pop		r17
		pop		r18

	ret

;========================================================
;			������� ������ � ds1302 �������
;			����� ������ ������� � �������� Z			
;========================================================

DS1302_read_package_data:
	push	r17

	;------------------------- ������

	rcall	DS1302_send_start
	ldi		BYTE, 0x83
	rcall	DS1302_send_byte
	rcall	DS1302_transmit_byte
	sts		minutes, BYTE
	rcall	DS1302_send_stop

	;------------------------- ����

	rcall	DS1302_send_start
	ldi		BYTE, 0x85
	rcall	DS1302_send_byte
	rcall	DS1302_transmit_byte
	sts		hours, BYTE
	rcall	DS1302_send_stop

	;------------------------- �����

	rcall	DS1302_send_start
	ldi		BYTE, 0x87
	rcall	DS1302_send_byte
	rcall	DS1302_transmit_byte
	sts		day, BYTE
	rcall	DS1302_send_stop

	;------------------------- �����

	rcall	DS1302_send_start
	ldi		BYTE, 0x89
	rcall	DS1302_send_byte
	rcall	DS1302_transmit_byte
	sts		month, BYTE
	rcall	DS1302_send_stop

	;------------------------- ���

	rcall	DS1302_send_start
	ldi		BYTE, 0x8D
	rcall	DS1302_send_byte
	rcall	DS1302_transmit_byte
	sts		year, BYTE
	rcall	DS1302_send_stop

	pop		r17

	ret