;	ATtiny2313a 8MHz
;========================================================
;       Задержка 3 мс.
;========================================================

/*delay_1ms_t0:
		push	r17
		ldi		r17, kdel2
		rjmp	delay_sts_1024
delay_3ms_t0:
		push	r17
		ldi		r17, kdel0
delay_sts_1024:
		out		OCR0A, r17
		ldi		r17, (1 << WGM01)							 ; Выбор режима таймера СТС 
		out		TCCR0A, r17
		ldi		r17, (1 << CS02) | (0 << CS01) | (1 << CS00) ; Выбор предделителя = 1024 
		out		TCCR0B, r17
		sei
delay_t0_loop:
		in		r17, TCCR0B
		cpi		r17, 0x00
		brne	delay_t0_loop
		pop		r17
		ret*/
