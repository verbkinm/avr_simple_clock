;------------------------- ������������ ��� ��������

.equ	kdel1		= 7813		 ; (1 ���. ��� 16-������� ������� �� 8��)
.equ	kdel0		= 5468 		 ; (0,7 ���. ��� 16-������� ������� �� 8��)
;.equ	kdel0		= 23		 ; (3 ��. ��� 8-������� ������� �� 8��)
;.equ	kdel2		= 8			 ; (1 ��. ��� 8-������� ������� �� 8��)

;------------------------- ��������/������� ��� ������ � tm1637

.def	reg_1       = r16
.def	reg_2       = r17
.def	reg_3       = r18
.def	reg_4	    = r19

.def	TM1637_d1   = r20
.def	TM1637_d2   = r21
.def	TM1637_d3   = r22
.def	TM1637_d4   = r23

.equ	PORT_TM1367	= PORTB
.equ	DDR_TM1367	= DDRB
.equ	PIN_TM1367	= PINB
.equ	TM1637_CLK  = PB3
.equ	TM1637_DATA = PB4

;------------------------- ��������/������� ��� ������ � ds1302

.equ	PORT_DS1302	= PORTB
.equ	DDR_DS1302	= DDRB
.equ	PIN_DS1302  = PINB
.equ	CE			= PB0
.equ	CLK			= PB1
.equ	DAT			= PB2
.def	BYTE		= r24	; ���� ������� � ���� ������ �� ds1302

;------------------------- ��������/������� ��� ������ � ��������

.equ	PORT_BUTTON_MODE	= PORTD
.equ	DDR_BUTTON_MODE		= DDRD
.equ	PIN_BUTTON_MODE		= PIND
.equ	BUTTON_MODE			= PD2

.equ	PORT_BUTTON_SET		= PORTD
.equ	DDR_BUTTON_SET		= DDRD
.equ	PIN_BUTTON_SET		= PIND
.equ	BUTTON_SET			= PB3