;========================================================
;			 ������ � EEPROM ������
;	����� - r18
;	������ ��� ������ - r17
;========================================================

EEPROM_write:
	push	r17
	push	r18

	sbic	EECR, EEPE
	rjmp	EEPROM_write
	out		EECR, CONST_ZERO
	out		EEARL, r18
	out		EEDR, r17
	sbi		EECR, EEMPE
	sbi		EECR, EEPE

	pop		r18
	pop		r17

	ret

;========================================================
;			 ������ �� EEPROM ������
;	����� - r17
;	������������ ������ - r17
;========================================================

EEPROM_read:
	sbic	EECR, EEPE
	rjmp	EEPROM_read
	out		EEARL, r17
	sbi		EECR, EERE
	in		r17, EEDR

	ret
