;========================================================
;       ������������ ��������� ����������
;========================================================

	;-------------------------- ���������� ��� ������� ����� ������

_INT0_or_1:
	push	r17

	rcall	MCU_wait_20ms					; ������� ���������

	in		r17, PIND
	andi	r17, 0x0C

	cpi		r17, 0x08						; ������ ������ ������ "Mode" (int0)
	breq	_INT01_MODE_press

	cpi		r17, 0x04						; ������ ������ ������ "Clock mode \ Set" (int1)
	breq	_INT01_SET_press

	cpi		r17, 0x00						; ������ ��� ������ - ��� �� ������ �������
	breq	_INT01_double_press

	rjmp	_INT0_or_1_end

	;-------------------------- ������� ������ Mode

	_INT01_MODE_press:
		rcall	Mode_pressed

		rjmp	_INT0_or_1_end

	;-------------------------- ������� ������ Clock mode \ Set

	_INT01_SET_press:
		rcall	Clock_mode_pressed

		rjmp	_INT0_or_1_end

	;-------------------------- ������� ���� ������

	_INT01_double_press:
		in		r17, PIND
		andi	r17, 0x0C
		cpi		r17, 0x0C
		brne	_INT01_double_press			; ������� ���� ������ �������� =))

		inc		tm_bright_level				; ������� �� 0 �� 7
		mov		r17, tm_bright_level
		cpi		r17, 0x08
		brlo	_INT01_double_press_set_bright
	
		clr		tm_bright_level

		_INT01_double_press_set_bright:
			rcall	TM1637_set_bright

	_INT0_or_1_end:
		pop		r17

	reti



;========================================================
;		 ������������ ��� ������� ������ Mode
;========================================================

Mode_pressed:
	push	r17
	push	r16

	_INT0_wait_release:
		sbis	PIN_BUTTON_MODE, BUTTON_MODE
		rjmp	_INT0_wait_release

	rcall	DS1302_read_package_data

	;-------------------------- ����� ���������� clock_mode

	clr		clock_mode

	;-------------------------- ��������� ���������� mode 

	inc		mode

	;-------------------------- ����� ������ mode

	cpi		mode, mode_1
	breq	Mode_pressed_1

	cpi		mode, mode_2
	breq	Mode_pressed_2

	cpi		mode, mode_3
	breq	Mode_pressed_3

	cpi		mode, mode_4
	breq	Mode_pressed_4

	cpi		mode, mode_5
	breq	Mode_pressed_5

	cpi		mode, mode_6
	breq	Mode_pressed_6

	cpi		mode, mode_7
	breq	Mode_pressed_7

	cpi		mode, mode_8
	breq	Mode_pressed_8

	cpi		mode, mode_9
	brsh	Mode_pressed_0

	rjmp	Mode_pressed_end

	;------------------------- MODE 0

	Mode_pressed_0:
		rcall	TM1637_display_time

		;------------------------- ���� ���� ��� ���������� ������, ��� ������������ � ���� ������, �� ������ ��� ��� ����������.
		;------------------------- ������: ��������� 31 �����, ����� 9 ����� (� � �������� 30 ����). ��� �������� � �����
		;------------------------- mode == 0 ��������������� 30 �����!

		lds		r17, bcd_day
		rcall	bcd8bin
		mov		r16, r17
		rcall	get_max_day
		cp		r16, r17
		brlo	Mode_pressed_0_end
		ldi		BYTE, 0x86
		rcall	DS1302_send_start
		rcall	DS1302_send_byte
		rcall	bin8bcd
		mov		BYTE, r17
		rcall	DS1302_send_byte
		rcall	DS1302_send_stop

		Mode_pressed_0_end:
			rcall	change_tim1_to_normal_mode
			clr		mode

		rjmp	Mode_pressed_end

	;------------------------- MODE 1

	Mode_pressed_1:
		rcall	TM1637_display_time
		rcall	change_tim1_to_blink_mode

		rjmp	Mode_pressed_end

	;------------------------- MODE 2

	Mode_pressed_2:
		rcall	TM1637_display_time

		rjmp	Mode_pressed_end

	;------------------------- MODE 3 ��� 4 

	Mode_pressed_3:
	Mode_pressed_4:
		rcall	TM1637_display_date

		rjmp	Mode_pressed_end

	;------------------------- MODE 5

	Mode_pressed_5:
		rcall	TM1637_display_year

		rjmp	Mode_pressed_end

	;------------------------- MODE 6

	Mode_pressed_6:
		rcall	TM1637_display_alarm_mode

		rjmp	Mode_pressed_end

	;------------------------- MODE 7 ��� 8

	Mode_pressed_7:
	Mode_pressed_8:
		rcall	TM1637_display_alarm

	Mode_pressed_end:
		pop		r16
		pop		r17

	reti

;========================================================
;	 ������������ ��� ������� ������ Clock mode \ Set
;========================================================

Clock_mode_pressed:
	push	r17

	_INT1_wait_release:
		sbis	PIN_BUTTON_SET, BUTTON_SET
		rjmp	_INT1_wait_release

	cpi		mode, mode_0
	breq	Clock_mode_clock_mode_pressed

	;-------------------------- ����� Set

	rcall	inc_circle

	rjmp	Clock_mode_end

	;-------------------------- ����� Clock mode

	Clock_mode_clock_mode_pressed:
		inc		clock_mode

		cpi		clock_mode, 0x03
		brsh	Clock_mode_reset
		rjmp	Clock_mode_pre_end

		Clock_mode_reset:
			clr		clock_mode

		Clock_mode_pre_end:

			;-------------------------- ����� ������ ����� ������������
			
			ldi		r17, high(kdel2)
			out		TCNT1H, r17
			ldi		r17, low(kdel2-10)
			out		TCNT1L, r17


	Clock_mode_end:
		pop		r17

	reti
	
;========================================================
;				���������� ������� T1	
;========================================================

_TIM1:		
	push	r17
	push	r18
	push	r19
	
	;-------------------------- �������� ������� Mode

	cpi		mode, mode_0
	breq	rcall_TIM1_mode_0

	cpi		mode, mode_1
	breq	rcall_TIM1_mode_1

	cpi		mode, mode_2
	breq	rcall_TIM1_mode_2

	cpi		mode, mode_3
	breq	rcall_TIM1_mode_3

	cpi		mode, mode_4
	breq	rcall_TIM1_mode_4

	cpi		mode, mode_5
	breq	rcall_TIM1_mode_5

	cpi		mode, mode_6
	breq	rcall_TIM1_mode_6

	cpi		mode, mode_7
	breq	rcall_TIM1_mode_7

	cpi		mode, mode_8
	breq	rcall_TIM1_mode_8

	cpi		mode, mode_9
	breq	rcall_TIM1_mode_9

	rjmp	_TIM1_end

	;-------------------------- MODE 0

	rcall_TIM1_mode_0:

		rcall	_TIM1_mode_0
		rcall	alarm_check

		rjmp	_TIM1_end

	;-------------------------- MODE 1

	rcall_TIM1_mode_1:
		lds		r18, tm_h1
		lds		r19, tm_h2
		ldi		r17, 0x01
		rcall	TM1637_blink_pair

		rjmp	_TIM1_end

	;-------------------------- MODE 2

	rcall_TIM1_mode_2:
		lds		r18, tm_m1
		lds		r19, tm_m2
		ldi		r17, 0x02
		rcall	TM1637_blink_pair

		rjmp	_TIM1_end

	;-------------------------- MODE 3

	rcall_TIM1_mode_3:
		lds		r18, tm_d1
		lds		r19, tm_d2
		ldi		r17, 0x01
		rcall	TM1637_blink_pair

		rjmp	_TIM1_end

	;-------------------------- MODE 4

	rcall_TIM1_mode_4:
		lds		r18, tm_mt1
		lds		r19, tm_mt2
		ldi		r17, 0x02
		rcall	TM1637_blink_pair

		rjmp	_TIM1_end

	;-------------------------- MODE 5

	rcall_TIM1_mode_5:
		lds		r18, tm_y3
		lds		r19, tm_y4
		ldi		r17, 0x02
		rcall	TM1637_blink_pair

		rjmp	_TIM1_end

	;-------------------------- MODE 6

	rcall_TIM1_mode_6:
		rcall	alarm_blink

		rjmp	_TIM1_end

	;-------------------------- MODE 7

	rcall_TIM1_mode_7:
		lds		r18, tm_ah1
		lds		r19, tm_ah2
		ldi		r17, 0x01
		rcall	TM1637_blink_pair

		rjmp	_TIM1_end

	;-------------------------- MODE 8

	rcall_TIM1_mode_8:
		lds		r18, tm_am1
		lds		r19, tm_am2
		ldi		r17, 0x02
		rcall	TM1637_blink_pair

		rjmp	_TIM1_end

	;-------------------------- MODE 9

	rcall_TIM1_mode_9:
		rcall	change_tim0_to_normal_mode
		clr		ZH
		ldi		ZL, low(tm_m1)
		ld		r18, Z+
		ld		r19, Z+
		ldi		r17, 0x02
		rcall	TM1637_blink_pair

		ld		r18, Z+
		ld		r19, Z
		ldi		r17, 0x01
		rcall	TM1637_blink_pair
		rcall	change_tim0_to_buzzer_mode

	_TIM1_end:

		pop		r19
		pop		r18
		pop		r17

	reti

;========================================================
;				���������� ������� T0	
;========================================================

_TIM0:
	push	r17
	push	BYTE

	in		r17, OCR0A
	cpi		r17, kdel4
	breq	_TIM0_end

	inc		timer0_counter_alarm_unlock
	sbrc	timer0_counter_alarm_unlock, 7		; 128 * 240 �� ~ 31 �
	clr		alarm_lock

	;-------------------------- ���� ������ �� Mode 0 � �� Clock_mode 0 ������� �� ����������

	push	mode
	add		mode, clock_mode
	pop		mode
	brne	_TIM0_end

	inc		timer0_counter
	mov		r17, timer0_counter
	cpi		r17, 0x03
	brne	_TIM0_end

	clr		timer0_counter

	;-------------------------- ��� �������� ������ �����������������. ���������� ������ �������� 2-�� �������� �� �������, � �� ����!!!

	rcall	TM1637_start
	ldi		BYTE, 0x44
	rcall	TM1637_send_byte
	rcall	TM1637_stop

	rcall	TM1637_start
	ldi		BYTE, 0xC1
	rcall	TM1637_send_byte
	lds		BYTE, tm_h2
	ldi		r17, 0x80
	eor		BYTE, r17
	sts		tm_h2, BYTE
	rcall	TM1637_send_byte
	rcall	TM1637_stop

	_TIM0_end:
		pop		BYTE
		pop		r17

	reti

;========================================================
;		������������ ������ ������ mode_0
;========================================================

_TIM1_mode_0:

	;-------------------------- ������� ������ � ds1302 �������

	rcall	DS1302_read_package_data

	cpi		clock_mode, clock_mode_1
	breq	_TIM1_date_mode

	cpi		clock_mode, clock_mode_2
	breq	_TIM1_year_mode

	_TIM1_time_mode:
		rcall	TM1637_display_time
		rjmp	_TIM1_mode_0_end

	_TIM1_date_mode:
		rcall	TM1637_display_date
		rjmp	_TIM1_mode_0_end

	_TIM1_year_mode:
		rcall	TM1637_display_year

	_TIM1_mode_0_end:
		rcall	TM1637_display

	ret