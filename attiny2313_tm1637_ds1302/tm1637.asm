; In this example used a cheap China 4-digit display 
; managed by TM1637 microchip, available at Aliexpress a lot.
;
; How to code displaying information
;
; In order to display some information call TM1637_display and fill registers
; TM1637_d1 .. TM1637_d4 with letters, that are coded next way:
;         0
;       +---+
;     5 | 6 | 1
;       +---+
;     4 |   | 2
;       +---+
;         3
; 
; Here the ordering numers is the bits layout in letters that to be passed to the called function.
; Number one coded as 0b00000110
; Number two coded as 0b01011011
; So this way, use bit=1 for diods to be burnt and bit=0 for bits that to be off.
;

;========================================================
;				 Отображение данных
;========================================================	

TM1637_display:
	push	reg_1
	push	reg_2
	push	reg_3

	;------------------------- Команда записи в регистр дисплея

	rcall	TM1637_start
	ldi		reg_1, 0x40			; Data command setting: Automatic address adding, Normal mode, Write data to display
	rcall	TM1637_writeByte
	rcall	TM1637_stop

	;------------------------- Начальный адрес 

	rcall	TM1637_start
	ldi		reg_1, 0xC0
	rcall	TM1637_writeByte

	;------------------------- Запись данных для каждого регистра дисплея

	mov		reg_1, TM1637_d1
	rcall	TM1637_writeByte

	mov		reg_1, TM1637_d2
	rcall	TM1637_writeByte

	mov		reg_1, TM1637_d3
	rcall	TM1637_writeByte

	mov		reg_1, TM1637_d4
	rcall	TM1637_writeByte

	rcall	TM1637_stop

	;------------------------- Команда управления дисплея

	rcall	TM1637_start
	ldi		reg_1, 0x8f
	rcall	TM1637_writeByte
	rcall	TM1637_stop
	nop

	pop		reg_3
	pop		reg_2
	pop		reg_1

	ret

; Expected byte in reg_1
; reg_1 contains a char to be written is to be passed as an argument of the call
; used temp registers: reg_1, reg_2, reg_3
; params: reg_1 - incoming char (8-bit) that to be sent out

;========================================================
;					Отправка байта
;========================================================

TM1637_writeByte:
	ldi		reg_2, 8

	TM1637_writeByte_1:
		cbi		PORT_TM1367, TM1637_CLK

	; starting if condition
		mov		reg_3, reg_1
		cbr		reg_3, 0xfe
		cpi		reg_3, 0x01
		brne	TM1637_writeByte_send_low

	TM1637_writeByte_send_high:
		sbi		PORT_TM1367, TM1637_DATA
		rjmp	TM1637_writeByte_sync

	TM1637_writeByte_send_low:
		cbi		PORT_TM1367, TM1637_DATA 
		rjmp	TM1637_writeByte_sync

	TM1637_writeByte_sync:
		nop
		lsr		reg_1 
		sbi		PORT_TM1367, TM1637_CLK                    
		nop

		dec		reg_2
		cpi		reg_2, 0                            ; end of 8-bit loop
		brne	TM1637_writeByte_1

		cbi		PORT_TM1367, TM1637_CLK
		nop
		cbi		DDR_TM1367, TM1637_DATA

	TM1637_writeByte_wait_ACK:
		sbic	PIN_TM1367, TM1637_DATA
		rjmp	TM1637_writeByte_wait_ACK          ; wait for acknowledgment
    
		sbi		DDR_TM1367, TM1637_DATA
		sbi		PORT_TM1367, TM1637_CLK
		nop
		cbi		PORT_TM1367, TM1637_CLK

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
	ori		TM1637_d4, 0x80
	rcall	TM1637_display
	pop		r17

	ret

TM1637_unset_double_point:
	push	r17
	ldi		r17, 0x00
	sts		double_point, r17
	andi	TM1637_d4, 0x7f
	rcall	TM1637_display
	pop		r17

	ret

;========================================================
;       Отображение прочерков на всех элементах
;========================================================

TM1637_display_dash:
	ldi		TM1637_d1, 0b01000000
	ldi		TM1637_d2, 0b01000000
	ldi		TM1637_d3, 0b01000000
	ldi		TM1637_d4, 0b01000000
	rcall	TM1637_display

	ret

;========================================================
;				Отображение времени
;========================================================

TM1637_display_time:
	lds		TM1637_d1, tm_h1
	lds		TM1637_d2, tm_h2
	lds		TM1637_d3, tm_m1
	lds		TM1637_d4, tm_m2

	rcall	TM1637_display

	ret

;========================================================
;				Отображение даты
;========================================================

TM1637_display_date:
	lds		TM1637_d1, tm_d1
	lds		TM1637_d2, tm_d2
	ori		TM1637_d2, 0x80
	lds		TM1637_d3, tm_mt1
	lds		TM1637_d4, tm_mt2
	rcall	TM1637_display

	ret

;========================================================
;				Отображение года
;========================================================

TM1637_display_year:
	lds		TM1637_d1, tm_y1
	lds		TM1637_d2, tm_y2
	lds		TM1637_d3, tm_y3
	lds		TM1637_d4, tm_y4
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
		eor		TM1637_d1, r18
		eor		TM1637_d2, r19

		rjmp	TM1637_blink_pair_end

	TM1637_blink_pair_second:
		eor		TM1637_d3, r18
		eor		TM1637_d4, r19

		rjmp	TM1637_blink_pair_end

	TM1637_blink_pair_third:
		lds		r17, tm_y1
		eor		TM1637_d1, r17

		lds		r17, tm_y2
		eor		TM1637_d2, r17

		eor		TM1637_d3, r18
		eor		TM1637_d4, r19


	TM1637_blink_pair_end:
		rcall	TM1637_display

		pop		r19
		pop		r18
		pop		r17

	ret
