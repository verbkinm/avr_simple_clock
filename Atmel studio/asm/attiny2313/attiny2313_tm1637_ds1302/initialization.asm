;========================================================
;				 ������ �������������
;========================================================

init:

	;-------------------------- ������������� �����
	
	ldi		r17, RAMEND			; ����� ������ ������� ����� 
	out		SPL, r17			; ������ ��� � ������� �����

	;--------------------------- ������������� �����������

	ldi 	r17, 0x80			; ���������� �����������
	out		ACSR, r17

	;-------------------------- ������������� �������� ������������

	ldi		r17, 0x80		    ; 
	out		CLKPR, r17			; 
	ldi		r17, 0x03			; ���������� 3 � ������� r17
	out		CLKPR, r17			; ���������� ��� ����� � CLKPR, ��������, ��� �� ����� ������� �� 8.

	;-------------------------- ������������� ������ �� �� ��������� (�� ���� � ������������� ����������)

	ser		r17
	out		PORTA, r17
	out		PORTB, r17
	out		PORTD, r17

	out		DDRA, CONST_ZERO
	out		DDRB, CONST_ZERO
	out		DDRD, CONST_ZERO

	;-------------------------- ������������� ����� �������

	cbi		PORT_BUZZER, BUZZER
	sbi		DDR_BUZZER, BUZZER

	;-------------------------- ������������� ������ �� ��� ���� TM1367

	sbi		DDR_TM1367, TM1637_CLK
	sbi		DDR_TM1367, TM1637_DATA

	;-------------------------- ������������� ������ �� ��� ���� DS1302

	sbi		DDR_DS1302, DS1302_CE
	sbi		DDR_DS1302, DS1302_SCLK

	;------------------------- ����� DS1302_DAT ��������������� ��� �������� ��� ������ ds1302

	;-------------------------- ������������� ������ �� ��� ������

	cbi		DDR_BUTTON_MODE, BUTTON_MODE
	cbi		DDR_BUTTON_SET, BUTTON_SET

	;-------------------------- ������������� ��������

	ldi		r17, (1 << WGM12) | (1 << CS12) | (0 << CS11) | (1 << CS10) ; ����� ������ ������� (���, ������������ = 1024) 
	out		TCCR1B, r17

	;-------------------------- ������ 1 

	ldi		r17, high(kdel1)	; 0.5 ���.
	out		OCR1AH, r17
	ldi		r17, low(kdel1)		 
	out		OCR1AL, r17

	;-------------------------- ������ 1 

	rcall	change_tim0_off

	;--------------------------- ��������� ���������� �� ��������
		
	ldi 	r17, (1 << OCIE1A) | (1 << OCIE0A)
	out		TIMSK, r17

	;--------------------------- ��������� ���������� INT0 � INT1 �� ������� ������ ;� ����� ��� (idle)

	ldi		r17, (1 << ISC01) | (0 << ISC00) | (1 << ISC11) | (0 << ISC10); | (1 << SE)
	out		MCUCR, r17

	ldi		r17, (1 << INT0) | (1 << INT1)
	out		GIMSK, r17