#define	kdel2		3906	// (0,5 сек. для 16-битного таймера на 8МГ)

// Регистры/описния для работы с TM1637
#define	PORT_TM1367	 PORTB
#define	DDR_TM1367	 DDRB
#define	PIN_TM1367	 PINB
#define	TM1637_CLK   PB0
#define	TM1637_DATA  PB3

// Регистры/описния для работы с ds1302
#define	PORT_DS1302	 PORTB
#define	DDR_DS1302	 DDRB
#define	PIN_DS1302   PINB
#define	DS1302_RST	 PB4
#define	DS1302_SCLK	 PB1
#define	DS1302_IO	 PB2

// Регистры/описния для работы с кнопками
#define	PORT_BUTTON_MODE	 PORTD
#define	DDR_BUTTON_MODE		 DDRD
#define	PIN_BUTTON_MODE		 PIND
#define	BUTTON_MODE			 PD2

#define	PORT_BUTTON_SET		 PORTD
#define	DDR_BUTTON_SET		 DDRD
#define	PIN_BUTTON_SET		 PIND
#define	BUTTON_SET			 PB3

// Глобальные переменные
uint8_t double_point = 0;	// Храниние состояния разделяющего двоеточия
							// (0 - показать, 1 - убарть)
uint8_t blink = 0;			// Состояние моргания при переключении режима mode
							// (0 - показать, 1 - убарть)
uint8_t clock_mode = 0;		// Храниние состояния отображения при режмиме mode =0
							// (время == 0, дата == 1, год == 2)
uint8_t mode = 0;			// Храниние позиции элемента, который устанавливается
							// (ничего не устанавливается == 0, часы == 1, минуты == 2, чисдо == 3, месяц == 4, год == 5)

// Хранение подготовленных данных для отображения на TM1637 по элементно
struct _Date
{
	uint8_t day[2];
	uint8_t month[2];
	uint8_t yearH[2];
	uint8_t yearL[2];
} DATE;

struct _Time
{
	 uint8_t hour[2];
	 uint8_t minute[2];
} TIME;