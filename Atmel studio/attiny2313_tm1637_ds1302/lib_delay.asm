;	ATtiny2313a 8MHz
;========================================================
;       �������� 3 ��.
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
		ldi		r17, (1 << WGM01)							 ; ����� ������ ������� ��� 
		out		TCCR0A, r17
		ldi		r17, (1 << CS02) | (0 << CS01) | (1 << CS00) ; ����� ������������ = 1024 
		out		TCCR0B, r17
		sei
delay_t0_loop:
		in		r17, TCCR0B
		cpi		r17, 0x00
		brne	delay_t0_loop
		pop		r17
		ret*/
