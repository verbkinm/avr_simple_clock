;========================================================
;		Смена режима TIM0
;========================================================

change_tim0_off:
	push	r17

	out		TCCR0A, CONST_ZERO
	out		TCCR0B, CONST_ZERO
	out		OCR0A, CONST_ZERO

	pop		r17

	ret

;========================================================
;		Смена режима TIM0
;========================================================

change_tim0_to_buzzer_mode:
	push	r17

	ldi		r17, (1 << WGM01) | (0 << COM0A1) | (1 << COM0A0)		
	out		TCCR0A, r17
	ldi		r17, (0 << CS02) | (1 << CS01) | (0 << CS00) 
	out		TCCR0B, r17
	ldi		r17, kdel4
	out		OCR0A, r17

	pop		r17

	ret