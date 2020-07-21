#pragma once

//========================================================
//			 Объявление функций DS1302
//========================================================

void DS1302_send_start(void);
void DS1302_send_stop(void);
void DS1302_send_byte(uint8_t byte);
 uint8_t DS1302_transmit_byte(void);

void DS1302_clock_on(void);
void DS1302_clock_off(void);

void DS1302_set_hours(uint8_t hours);
void DS1302_set_minutes(uint8_t minutes);

void DS1302_set_day(uint8_t day);
void DS1302_set_month(uint8_t month);

void DS1302_set_year(uint8_t year);

void  DS1302_set_data_byte(uint8_t addr_byte, uint8_t data_byte);

uint8_t  DS1302_get_hours(void);
uint8_t  DS1302_get_minutes(void);

uint8_t  DS1302_get_day(void);
uint8_t  DS1302_get_month(void);

uint8_t  DS1302_get_year(void);

uint8_t  DS1302_get_answer_byte(uint8_t addr_query);

//========================================================
//			 Реализация функций
//========================================================

void DS1302_send_start(void)
{
	PORT_DS1302 |= (1 << DS1302_RST);
	__asm__("nop");
	//_delay_ms(3);
}

void DS1302_send_stop(void)
{
	PORT_DS1302 &= ~( (1 << DS1302_SCLK) | (1 << DS1302_IO) );
	__asm__("nop");
	//_delay_ms(3);
	PORT_DS1302 &= ~(1 << DS1302_RST);
	__asm__("nop");
	//_delay_ms(3);
}

void DS1302_send_byte(uint8_t byte)
{
	// Вывод DAT на выход
	DDR_DS1302 |= 1 << DS1302_IO;
	PORT_DS1302 &= ~(1 << DS1302_IO);

	// Побитовая отправка байта
	for (uint8_t i = 0; i < 8; i++)
	{
		PORT_DS1302 &= 	~(1 << DS1302_SCLK);
		uint8_t send_bit = 0;
		send_bit = byte & 1;

		if(send_bit > 0)
			PORT_DS1302 |= 1 << DS1302_IO;
		else
			PORT_DS1302 &= ~(1 << DS1302_IO);

		__asm__("nop");
		//_delay_ms(3);
		
		PORT_DS1302 |= 1 << DS1302_SCLK;
		__asm__("nop");
		//_delay_ms(3);

		byte >>= 1;
	}
}

 uint8_t DS1302_transmit_byte(void)
{
	// Вывод DAT на вход
	PORT_DS1302 &= ~(1 << DS1302_IO);
	DDR_DS1302 &= ~(1 << DS1302_IO);

	uint8_t byte = 0;
	// Побитовый приём байта
	for (uint8_t i = 0; i < 7; i++)
	{
		PORT_DS1302 &= 	~(1 << DS1302_SCLK);
		
		uint8_t transmit_bit;
		transmit_bit = PIN_DS1302 & (1 << DS1302_IO);
		
		if(transmit_bit > 0)
			byte |= 0x80;
		else
			byte &= 0x7f;
		
		__asm__("nop");
		//_delay_ms(3);
		PORT_DS1302 |= 1 << DS1302_SCLK;
		__asm__("nop");
		//_delay_ms(3);
		
		byte >>= 1;
	}
	
	return byte;
}

void DS1302_clock_on(void)
{
	DS1302_send_start();
	DS1302_send_byte(0x80);
	DS1302_send_byte(0x00);
	DS1302_send_stop();
}

void DS1302_clock_off(void)
{
	DS1302_send_start();
	DS1302_send_byte(0x80);
	DS1302_send_byte(0x80);
	DS1302_send_stop();
}

void DS1302_set_hours(uint8_t hours)
{
	DS1302_set_data_byte(0x84, hours);
}

void DS1302_set_minutes(uint8_t minutes)
{
	DS1302_set_data_byte(0x82, minutes);
}

void DS1302_set_day(uint8_t day)
{
	DS1302_set_data_byte(0x86, day);
}

void DS1302_set_month(uint8_t month)
{
	DS1302_set_data_byte(0x88, month);
}

void DS1302_set_year(uint8_t year)
{
	DS1302_set_data_byte(0x8C, year);
}

void  DS1302_set_data_byte(uint8_t addr_byte, uint8_t data_byte)
{
	DS1302_send_start();
	DS1302_send_byte(addr_byte);
	DS1302_send_byte(data_byte);
	DS1302_send_stop();
}

 uint8_t  DS1302_get_hours(void)
{
	return DS1302_get_answer_byte(0x85);
}

 uint8_t  DS1302_get_minutes(void)
{
	return DS1302_get_answer_byte(0x83);
}

uint8_t  DS1302_get_day(void)
{
	return DS1302_get_answer_byte(0x87);
}

uint8_t  DS1302_get_month(void)
{
	return DS1302_get_answer_byte(0x89);
}

uint8_t  DS1302_get_year(void)
{
	return DS1302_get_answer_byte(0x8d);
}

 uint8_t  DS1302_get_answer_byte(uint8_t addr_query)
{
	uint8_t answer;
	DS1302_send_start();
	DS1302_send_byte(addr_query);
	answer = DS1302_transmit_byte();
	DS1302_send_stop();
	return answer;
}