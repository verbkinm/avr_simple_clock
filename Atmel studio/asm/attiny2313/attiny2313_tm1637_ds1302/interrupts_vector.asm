;========================================================
;				 ������ ����������
;========================================================		

	rjmp	init	; ������� �� ������ ���������
	rjmp	_INT0_or_1	; ������� ���������� 0
	rjmp	_INT0_or_1	; ������� ���������� 1
	reti			; ���������� �� ������� ������� T1
	rjmp 	_TIM1	; ���������� �� ���������� T1 A
	reti			; ���������� �� ������������ T1
	reti			; ���������� �� ������������ T0
	reti			; ���������� UART ����� ��������
	reti			; ���������� UART ������� ������ ����
	reti			; ���������� UART �������� ���������
	reti			; ���������� �� �����������
	reti			; ���������� �� ��������� �� ����� ��������
	reti			; ������/������� 1. ���������� B 
	rjmp 	_TIM0	; ������/������� 0. ���������� A
	reti			; ������/������� 0. ���������� B 
	reti			; USI ��������� ����������
	reti			; USI ������������
	reti			; EEPROM ����������
	reti			; ������������ ��������� �������