;========================================================
;				 ������ ����������
;========================================================		

	rjmp	init	; ������� �� ������ ���������
	rjmp	_INT0	; ������� ���������� 0
	rjmp	_INT1	; ������� ���������� 1
	reti			; ���������� �� ������� ������� T1
	rjmp 	_TIM1	; ���������� �� ���������� T1 A
	reti			; ���������� �� ������������ T1
	reti			; ���������� �� ������������ T0
	reti			; ���������� UART ����� ��������
	reti			; ���������� UART ������� ������ ����
	reti			; ���������� UART �������� ���������
	reti			; ���������� �� �����������
	reti		    ; ���������� �� ��������� �� ����� ��������
	reti			; ������/������� 1. ���������� B 
	reti 			; ������/������� 0. ���������� A
	reti			; ������/������� 0. ���������� B 
	reti			; USI ��������� ����������
	reti			; USI ������������
	reti			; EEPROM ����������
	reti			; ������������ ��������� �������
	reti			; PCINT1 Handler
	reti			; PCINT2 Handl