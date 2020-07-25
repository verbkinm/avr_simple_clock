;========================================================
;				 Отображение данных
;========================================================	

TM1637_display:
	push	BYTE

	;------------------------- Команда записи в регистр дисплея

	rcall	TM1637_start
	ldi		BYTE, 0x40					
	rcall	TM1637_send_byte
	rcall	TM1637_stop

	;------------------------- Начальный адрес 

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

	;------------------------- Команда управления дисплея

	rcall	TM1637_start
	ldi		BYTE, 0x8f
	rcall	TM1637_send_byte
	rcall	TM1637_stop

	pop		BYTE

	ret

;========================================================
;			Отправка байта из регистра BYTE
;========================================================

TM1637_send_byte:
	push	r17
	push	BYTE

	;------------------------- Счётчик цикла

	ldi		r17, 0x00	

	;------------------------- Начало цикла

	TM1637_while_send:
		cpi		r17, 0x08
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

			;------------------------- Отправка бита

			nop
			sbi		PORT_TM1367, TM1637_CLK                    
			nop

			inc		r17

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
		pop		r17

	ret

;========================================================
;       Подпрограммы начала и конца передачи данных
;========================================================

TM1637_start:
	sbi		PORT_TM1367, TM1637_CLK
	sbi		PORT_TM1367, TM1637_DATA
	cbi		PORT_TM1367, TM1637_DATA

	ret

TM1637_stop:
	cbi		PORT_TM1367, TM1637_CLK
	cbi		PORT_TM1367, TM1637_DATA
	sbi		PORT_TM1367, TM1637_CLK
	sbi		PORT_TM1367, TM1637_DATA

	ret

;========================================================
;       Включение и выключение двоеточия
;========================================================

TM1637_set_double_point:
	push	r17
	ldi		r17, 0x01
	sts		double_point, r17
	ori		TM1637_char4, 0x80
	rcall	TM1637_display
	pop		r17

	ret

TM1637_unset_double_point:
	push	r17
	ldi		r17, 0x00
	sts		double_point, r17
	andi	TM1637_char4, 0x7f
	rcall	TM1637_display
	pop		r17

	ret

;========================================================
;       Отображение прочерков на всех элементах
;========================================================

TM1637_display_dash:
	ldi		TM1637_char1, 0b01000000
	ldi		TM1637_char2, 0b01000000
	ldi		TM1637_char3, 0b01000000
	ldi		TM1637_char4, 0b01000000
	rcall	TM1637_display

	ret

;========================================================
;				Отображение времени
;========================================================

TM1637_display_time:
	lds		TM1637_char1, tm_h1
	lds		TM1637_char2, tm_h2
	lds		TM1637_char3, tm_m1
	lds		TM1637_char4, tm_m2

	rcall	TM1637_display

	ret

;========================================================
;				Отображение даты
;========================================================

TM1637_display_date:
	lds		TM1637_char1, tm_d1
	lds		TM1637_char2, tm_d2
	ori		TM1637_char2, 0x80
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
;				Моргание
;	Режимы: 
;		1-й и 2-й элементы r17==1
;		3-й и 4-й элементы r17==2
;		Все элементы r17==3
;
;	значение 1-го элемента == r18
;	значение 2-го элемента == r19
;========================================================

TM1637_blink_pair:
	push	r17
	push	r18
	push	r19

	cpi		r17, 0x01
	breq	TM1637_blink_pair_first

	cpi		r17, 0x02
	breq	TM1637_blink_pair_second

	cpi		r17, 0x03
	breq	TM1637_blink_pair_third

	rjmp	TM1637_blink_pair_end

	TM1637_blink_pair_first:
		eor		TM1637_char1, r18
		eor		TM1637_char2, r19

		rjmp	TM1637_blink_pair_end

	TM1637_blink_pair_second:
		eor		TM1637_char3, r18
		eor		TM1637_char4, r19

		rjmp	TM1637_blink_pair_end

	TM1637_blink_pair_third:
		lds		r17, tm_y1
		eor		TM1637_char1, r17

		lds		r17, tm_y2
		eor		TM1637_char2, r17

		eor		TM1637_char3, r18
		eor		TM1637_char4, r19


	TM1637_blink_pair_end:
		rcall	TM1637_display

		pop		r19
		pop		r18
		pop		r17

	ret
