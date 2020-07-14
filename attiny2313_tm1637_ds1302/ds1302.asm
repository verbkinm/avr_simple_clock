;========================================================
;       Подпрограммы начала и конца передачи данных
;========================================================

send_start:
		sbi		PORT_DS1302, CE
		nop
		ret
send_stop:
		cbi		PORT_DS1302, CLK
		cbi		PORT_DS1302, DAT
		nop
		cbi		PORT_DS1302, CE
		nop
		ret

;========================================================
;       Отправка байта
;========================================================

send_byte:
		push	r18
		push	r17
		push	r16

;------------------------- Вывод DAT на выход
		sbi		DDR_DS1302, DAT
		cbi		PORT_DS1302, DAT
;------------------------- Счётчик цикла
		ldi		r17, 0x00		
;------------------------- Начало цикла
while_send:
		cpi		r17, 0x08
		brsh	while_send_end

		cbi		PORT_DS1302, CLK

		lsr		BYTE			; сравниваем сдвинутый бит,
		ldi		r18, 0x00		; который в регистре С,
		ldi		r16, 0x00		; c байта (BYTE) с нулём
		cpc		r16, r18		;
		brcc	cbi_send_bit	
sbi_send_bit:
		sbi		PORT_DS1302, DAT
		rjmp	while_send_body_end
cbi_send_bit:
		cbi		PORT_DS1302, DAT

;------------------------- Конец тела цикла
while_send_body_end:
;------------------------- Отправка бита
		nop
		sbi		PORT_DS1302, CLK
		nop

		inc		r17
		rjmp	while_send

;------------------------- Выход из цикла
while_send_end:
		pop		r16
		pop		r17
		pop		r18
		ret

;========================================================
;       Получение байта
;========================================================
transmit_byte:
		push	r18
		push	r17

;------------------------- Вывод DAT на вход
		cbi		PORT_DS1302, DAT
		cbi		DDR_DS1302, DAT
;------------------------- Счётчик цикла
		ldi		r17, 0x00
		ldi		BYTE, 0x00
;------------------------- Начало цикла
while_transmit:
		cpi		r17, 0x07
		brsh	while_transmit_end

		cbi		PORT_DS1302, CLK

		sbic	PIN_DS1302, DAT
		ori		BYTE, 0x80
		sbis	PIN_DS1302, DAT
		andi	BYTE, 0x7f

;------------------------- Конец тела цикла
while_transmit_body_end:
		lsr		BYTE
		nop
		sbi		PORT_DS1302, CLK
		nop

		inc		r17
		rjmp	while_transmit

;------------------------- Выход из цикла
while_transmit_end:
		pop		r17
		pop		r18
		ret