/*
 * attiny2313_tm1637_ds1302.c
 *
 * Created: 17.07.2020 23:36:44
 * Author : verbkinm
 */ 

#include <avr/io.h>
//#include <avr/delay.h>

inline void MCU_init(void);
void read_package_data_from_ds1302(void);
void display_clock_mode(void);
void display_mode(uint8_t _1, uint8_t _2, uint8_t _3, uint8_t _4, uint8_t pair_number);
uint8_t max_day_month(void);

#include <avr/interrupt.h>
#include <avr/delay.h>


#include "def.h"
#include "data_convertor.h"
#include "ds1302.h"
#include "tm1637.h"
#include "interrupts.h"

int main(void)
{
	sei();
	MCU_init();
	TM1637_display_dash();
	
    while (1);
}

inline void MCU_init(void)
{
	DATE.yearH[1] = 0b01011011; //2
	DATE.yearH[0] = 0b00111111; //0
	
	// Инициализация стека
	SPL = RAMEND;
	
	// Инициализация стека
	CLKPR = 0x80;
	__asm__("nop");
	CLKPR = 0x00;
	
	// Выключение компаратора
	ACSR = 0x80;
	
	// Инициализация портов ВВ для чипа TM1367
	DDR_TM1367 |= (1 << DDR_TM1367) | (1 << DDR_TM1367);
	
	// Инициализация портов ВВ для чипа DS1302
	
	DDR_DS1302 |= (1 << DS1302_RST) | (1 << DS1302_SCLK);
	PORT_DS1302 |= (0 << DS1302_RST) | (0 << DS1302_SCLK);
	
	// Инициализация портов ВВ для кнопок
	DDR_BUTTON_MODE |= (0 << BUTTON_MODE);
	PORT_BUTTON_MODE |= (1 << BUTTON_MODE);

	DDR_BUTTON_SET |= (0 << BUTTON_SET);
	PORT_BUTTON_SET |= (1 << BUTTON_SET);
	
	// Инициализация таймеров
	TCCR1B |= (1 << WGM12) | (1 << CS12) | (0 << CS11) | (1 << CS10); // Выбор режима таймера (СТС, предделитель = 1024)
	OCR1A = kdel0;
		
	// Разрешаем прерывание от таймеров
	TIMSK |= (1 << OCIE1A);

	// Разрешаем прерывание INT0 и INT1 по заднему фронту
	MCUCR |= (0 << ISC00) | (1 << ISC01) | (0 << ISC10) | (1 << ISC11);
	GIMSK |= (1 << INT0) | (1 << INT1);
}

void read_package_data_from_ds1302(void)
{
	conv_ds1302_to_tm1637(DS1302_get_minutes(), TIME.minute);
	conv_ds1302_to_tm1637(DS1302_get_hours(), TIME.hour);

	conv_ds1302_to_tm1637(DS1302_get_day(), DATE.day);
	conv_ds1302_to_tm1637(DS1302_get_month(), DATE.month);
	
	conv_ds1302_to_tm1637(DS1302_get_year(), DATE.yearL);
}

void display_clock_mode(void)
{
	if(clock_mode == 0)
	{
		if(double_point == 1)
		{
			TIME.minute[0] |= 0x80;
			double_point = 0;
		}
		else
		{
			TIME.minute[0] &= ~0x80;
			double_point = 1;
		}
		TM1637_display(TIME.hour[1], TIME.hour[0], TIME.minute[1], TIME.minute[0]);
	}
	else if(clock_mode == 1)
		TM1637_display(DATE.day[1], DATE.day[0] | 0x80, DATE.month[1], DATE.month[0]);
	else if(clock_mode == 2)
		TM1637_display(DATE.yearH[1], DATE.yearH[0], DATE.yearL[1], DATE.yearL[0]);
}

void display_mode(uint8_t _1, uint8_t _2, uint8_t _3, uint8_t _4, uint8_t pair_number)
{
	if(blink == 1)
	{
		TM1637_display(_1, _2, _3, _4);
		blink = 0;
	}
	else
	{
		if(pair_number == 0)
			TM1637_display(0, 0, _3, _4);
		else if(pair_number == 1)
			TM1637_display(_1, _2, 0, 0);
		else
			TM1637_display(0, 0, 0, 0);
		
		blink = 1;
	}
}

uint8_t max_day_month(void)
{
	uint8_t month = DS1302_get_month();
	uint8_t year = DS1302_get_year();
	uint8_t max_day = max_day_in_month[bcd8bin(month)-1];
	
	if( (month == 0x02) && (year % 4 == 0) )
		max_day = 29;
		
	return max_day;
}