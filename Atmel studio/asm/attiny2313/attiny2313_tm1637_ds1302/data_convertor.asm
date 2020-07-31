;========================================================
;		�������������� ������ � ds1302 � 
;		����� ��� 4-� ����������� ������� tm1637
;		������ ���������� � �������� r16:r15 
;		���� - ������� BYTE
;========================================================

conv_ds1302_to_tm1637:
	push	r17

	;------------------------- ����������� ������� ������ � ������� r15

	mov		r17, BYTE
	andi	r17, 0x0f
	rcall	bin_to_tm1637_digit
	mov		r15, r17

	;------------------------- ����������� ������� ������ � ������� r16

	mov		r17, BYTE
	andi	r17, 0xf0
	swap	r17
	rcall	bin_to_tm1637_digit
	mov		r16, r17
	pop		r17

	ret

;------------------------- ���������� ��������������.
;------------------------- ������ �� �������� r17 ������������� � �������� 
;------------------------- �������� ��� 7-����������� ����������, ��������� � 
;------------------------- ������� r17

bin_to_tm1637_digit:
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
		rjmp	bin_to_tm1637_digit_end
	_d1:
		ldi		r17, 0b00000110
		rjmp	bin_to_tm1637_digit_end
	_d2:
		ldi		r17, 0b01011011
		rjmp	bin_to_tm1637_digit_end
	_d3:
		ldi		r17, 0b01001111
		rjmp	bin_to_tm1637_digit_end
	_d4:
		ldi		r17, 0b01100110
		rjmp	bin_to_tm1637_digit_end
	_d5:
		ldi		r17, 0b01101101
		rjmp	bin_to_tm1637_digit_end
	_d6:
		ldi		r17, 0b01111101
		rjmp	bin_to_tm1637_digit_end
	_d7:
		ldi		r17, 0b00000111
		rjmp	bin_to_tm1637_digit_end
	_d8:
		ldi		r17, 0b01111111
		rjmp	bin_to_tm1637_digit_end
	_d9:
		ldi		r17, 0b01101111
		rjmp	bin_to_tm1637_digit_end
	_dx:
		ldi		r17, 0b01001001
	
	bin_to_tm1637_digit_end:

	ret

;========================================================
;	������������ ���������� � �������������� ���������
;========================================================

inc_circle:
	push	r17
	push	r18
	push	r19

	lds		r17, mode

	;-------------------------- ����� ������ mode

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

	;-------------------------- ����

	inc_circle_hour:
		ldi		XH, high(bcd_hours)		
		ldi		XL, low(bcd_hours)
		ldi		r19, 0
		ldi		r18, 24
		ldi		BYTE, 0x84
		ldi		ZH, high(TM1637_display_time)
		ldi		ZL, low(TM1637_display_time)

		rcall	inc_circle_ext
		rcall	TM1637_set_double_point

		rjmp	inc_circle_end

	;-------------------------- ������

	inc_circle_minutes:
		ldi		XH, high(bcd_minutes)		
		ldi		XL, low(bcd_minutes)
		ldi		r19, 0
		ldi		r18, 60
		ldi		BYTE, 0x82
		ldi		ZH, high(TM1637_display_time)
		ldi		ZL, low(TM1637_display_time)

		rcall	inc_circle_ext
		rcall	TM1637_set_double_point

		rjmp	inc_circle_end

	;-------------------------- ���� ������

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

	;-------------------------- �����

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

	;-------------------------- ���

	inc_circle_year:
		ldi		XH, high(bcd_year)		
		ldi		XL, low(bcd_year)
		ldi		r18, 100
		ldi		BYTE, 0x8C
		ldi		ZH, high(TM1637_display_year)
		ldi		ZL, low(TM1637_display_year)

		rcall	inc_circle_ext

	;-------------------------- ����� �������������
			
	inc_circle_end:
		pop		r19
		pop		r18
		pop		r17

	ret

;========================================================
;		�������������� 8-������� ���������
;		�������� � ����������� BCD ������
;		��������\��������� �������� == BYTE
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
;		�������������� 8-������� ������������
;		�������� � �������� ������
;		��������\��������� �������� == r17
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
;	��������� ���������� �� ������ X.
;	������� ������� - max_digit (r18).
;	������ ������� - min_digit (r19).
;	����� �������� ��� DS1302 � �������� BYTE.
;	�������� ����� ������������ �� ������ Z
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

;========================================================
;	���������� ������������� ��� �������� ������
;	� ������ ���������� ���
;	��������� �������� == r17
;========================================================

get_max_day:
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

	ret

;========================================================
;	����������� ����������� ���� � ���������� 
;	���� ��� ���������� � ������ 2-� �����
;	��������� �������� r17 = 29
;========================================================

leap_year:
	push	r16

	;------------------------- ��������� �������� r17 � r16, ����� ��� �� �������� � ������, 
	;------------------------- ���� ������ �� ������� ����������� ����

	mov		r16, r17

	;------------------------- ���� ���������� �� �������, �������� �� ���������� ��� �� �����

	lds		r17, bcd_month
	cpi		r17, 0x02
	brne	leap_year_end

	;------------------------- ������ ����� ��� �� ����������

	lds		r17, bcd_year
	cpi		r17, 0x00
	breq	leap_year_end

	;------------------------- ���� ���� �� ���� ������� ����� ��� ��� �����������
	;------------------------- ����� �� ������ 4-�. ��� ����������

	rcall	bcd8bin
	sbrc	r17, 1
	rjmp	leap_year_end
	sbrc	r17, 0
	rjmp	leap_year_end

	;------------------------- ������������ �������� ����� ������ = 29

	ldi		r16, 29
		
	leap_year_end:
		mov		r17, r16
		pop		r16

	ret

;========================================================
;			������������ ������������ ��������
;========================================================

MCU_wait_10mks:						; 10 ��� + ����� �� ������� 
	push	r17

	ldi		r17, 10

	MCU_wait_loop:
		dec		r17
		brne	MCU_wait_loop

	pop		r17

	ret

MCU_wait_50ms:						; �������������� 51 �� + ����� ������
	push	r17
	push	r16

	ldi		r17, 200
	ser		r16

	MCU_wait_loop_L:
		dec		r16
		brne	MCU_wait_loop_L

	MCU_wait_loop_H:
		ser		r16
		dec		r17
		brne	MCU_wait_loop_L

	pop		r16
	pop		r17

	ret