;========================================================
;				 ����������� ������
;========================================================	

TM1637_display:
	push	BYTE

	;------------------------- ������� ������ � ������� �������

	rcall	TM1637_start
	ldi		BYTE, 0x40					
	rcall	TM1637_send_byte
	rcall	TM1637_stop

	;------------------------- ��������� ����� - ������ ������

	rcall	TM1637_start
	ldi		BYTE, 0xC0
	rcall	TM1637_send_byte

	;------------------------- ������ ������ ��� ������� �������� �������

	mov		BYTE, TM1637_char1
	rcall	TM1637_send_byte
	mov		BYTE, TM1637_char2
	rcall	TM1637_send_byte
	mov		BYTE, TM1637_char3
	rcall	TM1637_send_byte
	mov		BYTE, TM1637_char4
	rcall	TM1637_send_byte

	rcall	TM1637_stop

	rcall	TM1637_set_bright

	pop		BYTE

	ret

;========================================================
;			�������� ����� �� �������� BYTE
;========================================================

TM1637_send_byte:
	push	r16
	push	BYTE

	;------------------------- ������� �����

	clr		r16

	;------------------------- ������ �����

	TM1637_while_send:
		cpi		r16, 0x08
		brsh	TM1637_wait_ACK

		cbi		PORT_TM1367, TM1637_CLK

		lsr		BYTE
		brcc	TM1637_cbi_send_bit

		TM1637_sbi_send_bit:
			sbi		PORT_TM1367, TM1637_DATA
			rjmp	TM1637_while_send_bit

		TM1637_cbi_send_bit:
			cbi		PORT_TM1367, TM1637_DATA 

		TM1637_while_send_bit:

			;------------------------- �������� ����, �������� � ���� nop �� 1�� �������

			nop
			sbi		PORT_TM1367, TM1637_CLK                    
			nop

			inc		r16

			cbi		PORT_TM1367, TM1637_CLK
			nop
			cbi		PORT_TM1367, TM1637_DATA
			rjmp	TM1637_while_send

	;------------------------- �������� ���� ������

	TM1637_wait_ACK:
		sbic	PIN_TM1367, TM1637_DATA
		rjmp	TM1637_wait_ACK          
    
		sbi		DDR_TM1367, TM1637_DATA
		sbi		PORT_TM1367, TM1637_CLK
		nop
		cbi		PORT_TM1367, TM1637_CLK

		pop		BYTE
		pop		r16

	ret

;========================================================
;       ������������ ������ � ����� �������� ������
;========================================================

TM1637_start:
	sbi		PORT_TM1367, TM1637_CLK
	sbi		PORT_TM1367, TM1637_DATA
	nop
	cbi		PORT_TM1367, TM1637_DATA

	ret

TM1637_stop:
	cbi		PORT_TM1367, TM1637_CLK
	cbi		PORT_TM1367, TM1637_DATA
	nop
	sbi		PORT_TM1367, TM1637_CLK
	sbi		PORT_TM1367, TM1637_DATA

	ret

;========================================================
;				����������� �������
;========================================================

TM1637_display_time:
	lds		TM1637_char1, tm_h1
	lds		TM1637_char2, tm_h2
	sbr		TM1637_char2, 0b10000000
	lds		TM1637_char3, tm_m1
	lds		TM1637_char4, tm_m2

	rcall	TM1637_display

	ret

;========================================================
;				����������� ����
;========================================================

TM1637_display_date:
	lds		TM1637_char1, tm_d1
	lds		TM1637_char2, tm_d2
	lds		TM1637_char3, tm_mt1
	lds		TM1637_char4, tm_mt2

	rcall	TM1637_display

	ret

;========================================================
;				����������� ����
;========================================================

TM1637_display_year:
	lds		TM1637_char1, tm_y1
	lds		TM1637_char2, tm_y2
	lds		TM1637_char3, tm_y3
	lds		TM1637_char4, tm_y4

	rcall	TM1637_display

	ret

;========================================================
;				����������� ������� ����������
;========================================================

TM1637_display_alarm:
	lds		TM1637_char1, tm_ah1
	lds		TM1637_char2, tm_ah2
	sbr		TM1637_char2, 0b10000000
	lds		TM1637_char3, tm_am1
	lds		TM1637_char4, tm_am2

	rcall	TM1637_display

	ret

;========================================================
;		����������� ������ ���������� (���.\����)
;========================================================

TM1637_display_alarm_mode:
	push	r17
	
	ldi		TM1637_char1, char_A
	ldi		TM1637_char2, char_minus
	ldi		TM1637_char3, char_0
		
	sbrc	alarm, 0
	ldi		TM1637_char4, char_N
	sbrs	alarm, 0
	ldi		TM1637_char4, char_F

	rcall	TM1637_display

	pop		r17

	ret

;========================================================
;				��������
;	������: 
;		1-� � 2-� �������� r17==1
;		3-� � 4-� �������� r17==2
;	�������� 1-�� ���������� �������� == r18
;	�������� 2-�� ���������� �������� == r19
;========================================================

TM1637_blink_pair:
	push	r19
	push	r18
	push	r17

	cpi		r17, 0x01
	breq	TM1637_blink_pair_first

	cpi		r17, 0x02
	breq	TM1637_blink_pair_second

	rjmp	TM1637_blink_pair_end

	TM1637_blink_pair_first:
		eor		TM1637_char1, r18
		eor		TM1637_char2, r19

		rjmp	TM1637_blink_pair_end

	TM1637_blink_pair_second:
		eor		TM1637_char3, r18
		eor		TM1637_char4, r19

		rjmp	TM1637_blink_pair_end

	TM1637_blink_pair_end:
		rcall	TM1637_display

		pop		r19
		pop		r18
		pop		r17

	ret

;========================================================
; ��������� ������� �������. �������� �������� (0..7)
; � �������� tm_bright_level, ��� �������� ��������� 
; ��������
;========================================================

TM1637_set_bright:
	push	BYTE

	mov		BYTE, tm_bright_level
	sbr		BYTE, 0x88

	rcall	TM1637_start
	rcall	TM1637_send_byte
	rcall	TM1637_stop

	pop		BYTE

	ret