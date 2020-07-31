;------------------------- ������������ ��� ��������

.equ	kdel1		= 7813		 ; (1 ���. ��� 16-������� ������� �� 8��)
.equ	kdel2		= 3906		 ; (0,5 ���. ��� 16-������� ������� �� 8��)
.equ	kdel3		= 250		 ; (32 ��. ��� 8-������� ������� �� 8��)

;------------------------- ��������/�������� ��� ������ � tm1637

.def	reg_1       = r16
.def	reg_2       = r17
.def	reg_3       = r18

.def	TM1637_d1   = r20
.def	TM1637_d2   = r21
.def	TM1637_d3   = r22
.def	TM1637_d4   = r23

.equ	PORT_TM1367	= PORTB
.equ	DDR_TM1367	= DDRB
.equ	PIN_TM1367	= PINB
.equ	TM1637_CLK  = PB0
.equ	TM1637_DATA = PB3

;------------------------- ��������/�������� ��� ������ � ds1302

.equ	PORT_DS1302	= PORTB
.equ	DDR_DS1302	= DDRB
.equ	PIN_DS1302  = PINB
.equ	DS1302_RST	= PB0
.equ	DS1302_SCLK	= PB1
.equ	DS1302_IO	= PB2
.def	BYTE		= r24	; ���� ������� � ���� ������ �� ds1302

;------------------------- ��������/�������� ��� ������ � ��������

.equ	PORT_BUTTON_MODE	= PORTD
.equ	DDR_BUTTON_MODE		= DDRD
.equ	PIN_BUTTON_MODE		= PIND
.equ	BUTTON_MODE			= PD2

.equ	PORT_BUTTON_SET		= PORTA
.equ	DDR_BUTTON_SET		= DDRA
.equ	PIN_BUTTON_SET		= PINA
.equ	BUTTON_SET			= PA2