;------------------------- ѕредделители дл€ таймеров

;.equ	kdel1		= 7813		 ; (1 сек. дл€ 16-битного таймера на 8ћ√)
.equ	kdel2		= 7499		 ; (60 сек. дл€ 16-битного таймера на 128к√ц)
.equ	kdel3		= 62		 ; (0,5 сек дл€ 8-битного таймера на 128к√ц)

;------------------------- –егистры/описани€ дл€ работы с tm1637

.def	TM1637_char1   = r20
.def	TM1637_char2   = r21
.def	TM1637_char3   = r22
.def	TM1637_char4   = r23

.equ	PORT_TM1367	= PORTB
.equ	DDR_TM1367	= DDRB
.equ	PIN_TM1367	= PINB
.equ	TM1637_CLK  = PB0
.equ	TM1637_DATA = PB3

;------------------------- –егистры/описани€ дл€ работы с ds1302

.equ	PORT_DS1302	= PORTB
.equ	DDR_DS1302	= DDRB
.equ	PIN_DS1302  = PINB
.equ	DS1302_CE	= PB4
.equ	DS1302_SCLK	= PB1
.equ	DS1302_IO	= PB2
.def	BYTE		= r24	; байт отсылки и приЄм данных из ds1302

;------------------------- –егистры/описани€ дл€ работы с кнопками

.equ	PORT_BUTTON_MODE	= PORTD
.equ	DDR_BUTTON_MODE		= DDRD
.equ	PIN_BUTTON_MODE		= PIND
.equ	BUTTON_MODE			= PD2

.equ	PORT_BUTTON_SET		= PORTD
.equ	DDR_BUTTON_SET		= DDRD
.equ	PIN_BUTTON_SET		= PIND
.equ	BUTTON_SET			= PD3
