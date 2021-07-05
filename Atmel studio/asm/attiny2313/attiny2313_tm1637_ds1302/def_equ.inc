;------------------------- Предделители для таймеров

.equ	kdel1			= 487		; (0,5 сек. для 16-битного таймера на 1МГц)
;.equ	kdel2			= 58593		; (60 сек. для 16-битного таймера на 1МГц)
.equ	kdel3			= 233		; (240 мс для 8-битного таймера на 1МГц)
.equ	kdel4			= 125		; (1000 Гц для 8-битного таймера на 1МГц)

;------------------------- Регистры/описания для работы с tm1637

.def	TM1637_char1	= r6
.def	TM1637_char2	= r23
.def	TM1637_char3	= r24
.def	TM1637_char4	= r25

.equ	PORT_TM1367		= PORTB
.equ	DDR_TM1367		= DDRB
.equ	PIN_TM1367		= PINB
.equ	TM1637_CLK		= PB0
.equ	TM1637_DATA		= PB1

;------------------------- Постоянные символы для tm1637

.equ	char_A			= 0b01110111
.equ	char_minus		= 0b01000000
.equ	char_3_dash		= 0b01001001
.equ	char_N			= 0b00110111
.equ	char_F			= 0b01110001
.equ	char_O			= 0b00111111

.equ	char_0			= char_O
.equ	char_1			= 0b00000110
.equ	char_2			= 0b01011011
.equ	char_3			= 0b01001111
.equ	char_4			= 0b01100110
.equ	char_5			= 0b01101101
.equ	char_6			= 0b01111101
.equ	char_7			= 0b00000111
.equ	char_8			= 0b01111111
.equ	char_9			= 0b01101111

;------------------------- Режимы Mode для tm1637

.equ	mode_0			= 0x00
.equ	mode_1			= 0x01
.equ	mode_2			= 0x02
.equ	mode_3			= 0x03
.equ	mode_4			= 0x04
.equ	mode_5			= 0x05
.equ	mode_6			= 0x06
.equ	mode_7			= 0x07
.equ	mode_8			= 0x08
.equ	mode_9			= 0x09
.equ	mode_10			= 0x0A

;------------------------- Регистры/описания для работы с ds1302

.equ	PORT_DS1302		= PORTB
.equ	DDR_DS1302		= DDRB
.equ	PIN_DS1302		= PINB
.equ	DS1302_SCLK		= PB3
.equ	DS1302_IO		= PB4
.equ	DS1302_CE		= PB5		; RST

;------------------------- Режимы Clock_mode для ds1302

.equ	clock_mode_0	= 0x00
.equ	clock_mode_1	= 0x01
.equ	clock_mode_2	= 0x02

;------------------------- Регистры/описания для работы с кнопками

.equ	PORT_BUTTON_MODE= PORTD
.equ	DDR_BUTTON_MODE	= DDRD
.equ	PIN_BUTTON_MODE	= PIND
.equ	BUTTON_MODE		= PD2

.equ	PORT_BUTTON_SET	= PORTD
.equ	DDR_BUTTON_SET	= DDRD
.equ	PIN_BUTTON_SET	= PIND
.equ	BUTTON_SET		= PD3

;------------------------- Регистры/описания для зуммера

.equ	PORT_BUZZER		= PORTB
.equ	DDR_BUZZER		= DDRB
.equ	PIN_BUZZER		= PINB
.equ	BUZZER			= PB2
