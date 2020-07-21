#pragma once

//========================================================
//			 Объявление функций TM1637
//========================================================

void TM1637_send_start(void);
void TM1637_send_stop(void);

void TM1637_send_byte(uint8_t byte);

void TM1637_display(uint8_t d1, uint8_t d2, uint8_t d3, uint8_t d4);
void TM1637_display_dash(void);

//========================================================
//			 Реализация функций
//========================================================

void TM1637_send_start(void)
{
	PORT_TM1367 |= (1 << TM1637_CLK) | (1 << TM1637_DATA);
	__asm__("nop");
	//_delay_ms(3);
}

void TM1637_send_stop(void)
{
	PORT_TM1367 |= (1 << TM1637_CLK);
	__asm__("nop");
	//_delay_ms(3);
	PORT_TM1367 |= (1 << TM1637_DATA);
}

void TM1637_send_byte(uint8_t byte)
{
	PORT_TM1367 &= ~(1 << TM1637_DATA);
	//_delay_ms(3);
	PORT_TM1367 &= ~(1 << TM1637_CLK);
	
	for (uint8_t i = 0; i < 8; i++)
	{
		uint8_t send_bit = 0;
		send_bit = byte & 1;

		if(send_bit > 0)
			PORT_TM1367 |= (1 << TM1637_DATA);
		else
			PORT_TM1367 &= ~(1 << TM1637_DATA);
			
		__asm__("nop");
		//_delay_ms(3);
		PORT_TM1367 |= 1 << TM1637_CLK;
		__asm__("nop");
		//_delay_ms(3);
		PORT_TM1367 &= ~(1 << TM1637_CLK);
		
		byte >>= 1;
	}
	
	PORT_TM1367 &= ~(1 << TM1637_CLK);
	PORT_TM1367 &= ~(1 << TM1637_DATA);
	DDR_TM1367 &= ~(1 << TM1637_DATA);
	__asm__("nop");
	//_delay_ms(3);
	
	uint8_t transmit_bit = 0;
	transmit_bit = PIN_TM1367 & TM1637_DATA;
	
	while (transmit_bit > 0);
	
	DDR_TM1367 |= (1 << TM1637_DATA);
	PORT_TM1367 |= (1  << TM1637_CLK);
	__asm__("nop");
	//_delay_ms(3);
	PORT_TM1367 &= ~(1  << TM1637_CLK);
	__asm__("nop");
	//s_delay_ms(3);
}

void TM1637_display(uint8_t d1, uint8_t d2, uint8_t d3, uint8_t d4)
{
	TM1637_send_start();
	TM1637_send_byte(0x40);
	TM1637_send_stop();
	
	TM1637_send_start();
	TM1637_send_byte(0xC0);
	TM1637_send_byte(d1);
	TM1637_send_byte(d2);
	TM1637_send_byte(d3);
	TM1637_send_byte(d4);
	TM1637_send_stop();
	
	TM1637_send_start();
	TM1637_send_byte(0x8f);
	TM1637_send_stop();
}

void TM1637_display_dash(void)
{
	TM1637_display(0b01000000, 0b01000000, 0b01000000, 0b01000000);
}
