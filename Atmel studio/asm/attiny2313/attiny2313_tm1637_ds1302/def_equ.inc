;------------------------- Предделители для таймеров

.equ	kdel1			= 487		; (0,5 сек. для 16-битного таймера на 1МГц)
.equ	kdel2			= 58593		; (60 сек. для 16-битного таймера на 1МГц)
.equ	kdel3			= 233		; (240 мс для 8-битного таймера на 1МГц)
.equ	kdel4			= 125		; (1000 Гц для 8-битного таймера на 1МГц)

;------------------------- Регистры/описания для работы с tm1637

.def	TM1637_char1	= r20
.def	TM1637_char2	= r21
.def	TM1637_char3	= r22
.def	TM1637_char4	= r23

.equ	PORT_TM1367		= PORTB
.equ	DDR_TM1367		= DDRB
.equ	PIN_TM1367		= PINB
.equ	TM1637_CLK		= PB0
.equ	TM1637_DATA		= PB1

;------------------------- Регистры/описания для работы с ds1302

.equ	PORT_DS1302		= PORTB
.equ	DDR_DS1302		= DDRB
.equ	PIN_DS1302		= PINB
.equ	DS1302_CE		= PB3
.equ	DS1302_SCLK		= PB4
.equ	DS1302_IO		= PB5


;------------------------- Регистры/описания для работы с кнопками

.equ	PORT_BUTTON_MODE= PORTD
.equ	DDR_BUTTON_MODE	= DDRD
.equ	PIN_BUTTON_MODE	= PIND
.equ	BUTTON_MODE		= PD2

.equ	PORT_BUTTON_SET	= PORTD
.equ	DDR_BUTTON_SET	= DDRD
.equ	PIN_BUTTON_SET	= PIND
.equ	BUTTON_SET		= PD3


.equ	char_A			= 0b01110111
.equ	char_minus		= 0b01000000
.equ	char_N			= 0b00110111
.equ	char_F			= 0b01110001
.equ	char_O			= 0b00111111

;------------------------- Регистры/описания для зуммер

.equ	PORT_BUZZER		= PORTB
.equ	DDR_BUZZER		= DDRB
.equ	PIN_BUZZER		= PINB
.equ	BUZZER			= PB2