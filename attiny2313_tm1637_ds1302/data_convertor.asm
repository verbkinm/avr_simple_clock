;========================================================
;		�������������� ������ � ds1302 � 
;		����� ��� 4-� ����������� ������� tm1637
;		������ ���������� � ���������� d1 � d2
;========================================================

conv_ds1302_to_tm1637:
	push	r17

	;------------------------- ����������� ������� ������ � ���������� d2

	mov		r17, BYTE
	andi	r17, 0x0f
	rcall	bin_to_tm1637_digit
	lds		r17, d1
	sts		d2, r17

	;------------------------- ����������� ������� ������ � ���������� d1

	mov		r17, BYTE
	andi	r17, 0x70
	lsr		r17
	lsr		r17
	lsr		r17
	lsr		r17
	rcall	bin_to_tm1637_digit
	pop		r17

	ret

;------------------------- ���������� ��������������.
;------------------------- ������ �� �������� r17 ������������� � �������� 
;------------------------- �������� ��� 7-����������� ����������, ��������� � 
;------------------------- ���������� d1

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

	;------------------------- ������������ ��� ����� 0..9

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
; ������������ ������ ������ ����������� (�����/����/���)
;========================================================

prepare_display:
	push	r17
	push	r18

	;-------------------------- ���� ������ ����

	cpi		r18, 0x8D
	brne	prepare_display_1

	rcall	DS1302_send_start
	mov		BYTE, r18
	rcall	DS1302_send_byte
	rcall	DS1302_transmit_byte
	rcall	DS1302_send_stop

	rcall	conv_ds1302_to_tm1637

	ldi		TM1637_d1, 0b01011011	; 2 2000-� ���
	ldi		TM1637_d2, 0b00111111	; 0 2000-� ���
	lds		TM1637_d3, d1
	lds		TM1637_d4, d2

	;-------------------------- ������ ��������� � ������ ����� ����� ������� ����� (���)

	rcall	TM1637_unset_double_point
	andi	TM1637_d2, 0x7f

	rjmp	prepare_display_end

	prepare_display_1:

		;-------------------------- ������ �������� �� �������� r17

		rcall	DS1302_send_start
		mov		BYTE, r17
		rcall	DS1302_send_byte
		rcall	DS1302_transmit_byte
		rcall	DS1302_send_stop

		rcall	conv_ds1302_to_tm1637

		lds		TM1637_d1, d1
		lds		TM1637_d2, d2

		;-------------------------- ������ �������� �� �������� r18

		rcall	DS1302_send_start
		mov		BYTE, r18
		rcall	DS1302_send_byte
		rcall	DS1302_transmit_byte
		rcall	DS1302_send_stop

		rcall	conv_ds1302_to_tm1637

		lds		TM1637_d3, d1
		lds		TM1637_d4, d2


		lds		r17, clock_mode

		cpi		r17, 0x00
		breq	prepare_display_time

		cpi		r17, 0x01
		breq	prepare_display_date

	;-------------------------- ���������� ��������� � ������ ����� ����� ������� ����� (�����)

	prepare_display_time:

		lds		r17, double_point
		sbrc	r17, 0
		rcall	TM1637_unset_double_point
		sbrs	r17, 0
		rcall	TM1637_set_double_point
		andi	TM1637_d2, 0x7f

		rjmp	prepare_display_end

	;-------------------------- ������ ��������� � ���������� ����� ����� ������� ����� (����)

	prepare_display_date:
		rcall	TM1637_unset_double_point
		ori		TM1637_d2, 0x80

	prepare_display_end:
		pop		r18
		pop		r17

	ret