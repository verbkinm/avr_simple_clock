;========================================================
;       Подпрограммы начала и конца передачи данных
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
;			Отправка байта из регистра BYTE
;========================================================

TM1637_send_byte:
	push	r16
	push	BYTE

	;------------------------- Счётчик цикла

	clr		r16

	;------------------------- Начало цикла

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

			;------------------------- Отправка бита, задержки в один nop на 1МГ хватает

			nop
			sbi		PORT_TM1367, TM1637_CLK                    
			nop

			inc		r16

			cbi		PORT_TM1367, TM1637_CLK
			nop
			cbi		PORT_TM1367, TM1637_DATA
			rjmp	TM1637_while_send

	;------------------------- Ожидания бита ответа

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
;				 Отображение данных
;========================================================	

TM1637_display:
	push	BYTE

	;------------------------- Команда записи в регистр дисплея c автоматическим инкрементом адреса

	rcall	TM1637_start
	ldi		BYTE, 0x40					
	rcall	TM1637_send_byte
	rcall	TM1637_stop

	;------------------------- Начальный адрес - первый символ дисплея

	rcall	TM1637_start
	ldi		BYTE, 0xC0
	rcall	TM1637_send_byte

	;------------------------- Запись данных для каждого регистра дисплея

	mov		BYTE, TM1637_char1
	rcall	TM1637_send_byte
	mov		BYTE, TM1637_char2
	rcall	TM1637_send_byte
	mov		BYTE, TM1637_char3
	rcall	TM1637_send_byte
	mov		BYTE, TM1637_char4
	rcall	TM1637_send_byte

	rcall	TM1637_stop

	pop		BYTE

	ret

;========================================================
;				 Установка яркости
;	BYTE (4-и младших бита) = яркость.
;========================================================	

TM1637_set_ligth:
	push	BYTE

	ori		BYTE, 0x88

	rcall	TM1637_start
	rcall	TM1637_send_byte
	rcall	TM1637_stop

	pop		BYTE

	ret

;========================================================
;				Отображение времени
;========================================================

TM1637_display_time:
	lds		TM1637_char1, tm_h1
	lds		TM1637_char2, tm_h2

	or		TM1637_char2, tm1637_dot

	lds		TM1637_char3, tm_m1
	lds		TM1637_char4, tm_m2

	rcall	TM1637_display

	ret

;========================================================
;				Отображение секунд
;========================================================

TM1637_display_seconds:
	lds		TM1637_char1, tm_m1
	lds		TM1637_char2, tm_m2
	sbr		TM1637_char2, 0b10000000
	lds		TM1637_char3, tm_s1
	lds		TM1637_char4, tm_s2

	rcall	TM1637_display

	ret

;========================================================
;				Отображение даты
;========================================================

TM1637_display_date:
	lds		TM1637_char1, tm_d1
	lds		TM1637_char2, tm_d2
	lds		TM1637_char3, tm_mt1
	lds		TM1637_char4, tm_mt2

	rcall	TM1637_display

	ret

;========================================================
;				Отображение года
;========================================================

TM1637_display_year:
	lds		TM1637_char1, tm_y1
	lds		TM1637_char2, tm_y2
	lds		TM1637_char3, tm_y3
	lds		TM1637_char4, tm_y4

	rcall	TM1637_display

	ret

;========================================================
;				Отображение времени будильника
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
;		Отображение режима будильника (вкл.\ выкл.)
;========================================================

TM1637_display_alarm_mode:
	push	r17
	
	ldi		r17, char_A
	mov		TM1637_char1, r17
	ldi		TM1637_char2, char_minus
	ldi		TM1637_char3, char_0
	
	ldi		r17, alarm_state
	rcall	EEPROM_read
		
	sbrc	r17, 0
	ldi		TM1637_char4, char_N
	sbrs	r17, 0
	ldi		TM1637_char4, char_F

	rcall	TM1637_display

	pop		r17

	ret

;========================================================
;		Отображение яркости tm1632
;========================================================

TM1637_display_light:
	mov		TM1637_char1, CONST_ZERO
	mov		TM1637_char2, CONST_ZERO
	mov		TM1637_char3, CONST_ZERO
	lds		TM1637_char4, tm_light
	rcall	TM1637_display

	ret

;========================================================
;				Моргание
;	Режимы моргания: 
;		1-й и 2-й элементы r17==1
;		3-й и 4-й элементы r17==2
;	значение 1-го моргающего элемента == r18
;	значение 2-го моргающего элемента == r19
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
;					Анимация №1
;========================================================

TM1637_animation_1:
	ldi		r17, 0x01
	mov		TM1637_char1, r17
	mov		TM1637_char2, CONST_ZERO
	mov		TM1637_char3, CONST_ZERO
	mov		TM1637_char4, CONST_ZERO
	rcall	TM1637_animation_1_ext

	mov		TM1637_char2, r17
	rcall	TM1637_animation_1_ext
	
	mov		TM1637_char3, r17
	rcall	TM1637_animation_1_ext

	rcall	TM1637_animation_1_ext_1

	ldi		r17, 0x03
	rcall	TM1637_animation_1_ext_1

	ldi		r17, 0x07
	rcall	TM1637_animation_1_ext_1

	ldi		r17, 0x0F
	rcall	TM1637_animation_1_ext_1

	ldi		r17, 0x09
	mov		TM1637_char3, r17
	rcall	TM1637_animation_1_ext

	mov		TM1637_char2, r17
	rcall	TM1637_animation_1_ext

	mov		TM1637_char1, r17
	rcall	TM1637_animation_1_ext

	ldi		r17, 0x19
	mov		TM1637_char1, r17
	rcall	TM1637_animation_1_ext

	ldi		r17, 0x39
	mov		TM1637_char1, r17
	rcall	TM1637_animation_1_ext

	ldi		r17, char_8
	mov		TM1637_char1, r17
	mov		TM1637_char3, r17
	mov		TM1637_char4, r17
	ori		r17, 0x80
	mov		TM1637_char2, r17
	rcall	TM1637_animation_1_ext
	rcall	MCU_wait_300ms
	rcall	MCU_wait_300ms


	ret

TM1637_animation_1_ext:
	rcall	TM1637_display
	rcall	MCU_wait_300ms

	ret

TM1637_animation_1_ext_1:
	mov		TM1637_char4, r17
	rcall	TM1637_animation_1_ext

	ret