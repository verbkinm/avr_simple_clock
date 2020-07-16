;------------------------- Предделители для таймеров

.equ	kdel1		= 7813		 ; (1 сек. для 16-битного таймера на 8МГ)
.equ	kdel0		= 5468 		 ; (0,7 сек. для 16-битного таймера на 8МГ)
.equ	kdel2		= 3906		 ; (0,5 сек. для 16-битного таймера на 8МГ)
.equ	kdel3		= 250		 ; (32 мс. для 8-битного таймера на 8МГ)

;------------------------- Регистры/описния для работы с tm1637

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

;------------------------- Регистры/описния для работы с ds1302

.equ	PORT_DS1302	= PORTB
.equ	DDR_DS1302	= DDRB
.equ	PIN_DS1302  = PINB
.equ	CE			= PB0
.equ	CLK			= PB1
.equ	DAT			= PB2
.def	BYTE		= r24	; байт отсылки и приём данных из ds1302

;------------------------- Регистры/описния для работы с кнопками

.equ	PORT_BUTTON_MODE	= PORTD
.equ	DDR_BUTTON_MODE		= DDRD
.equ	PIN_BUTTON_MODE		= PIND
.equ	BUTTON_MODE			= PD2

.equ	PORT_BUTTON_SET		= PORTD
.equ	DDR_BUTTON_SET		= DDRD
.equ	PIN_BUTTON_SET		= PIND
.equ	BUTTON_SET			= PB3

;------------------------- Глобальные переменные

;.def	MAX_DIGIT			= r25