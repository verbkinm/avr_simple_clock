#pragma once

uint8_t bin8bcd(uint8_t byte);
uint8_t bcd8bin(uint8_t bcd_byte);

uint8_t inc_circle(uint8_t digit, uint8_t min, uint8_t max);

void conv_ds1302_to_tm1637(uint8_t ds1302_digit,  uint8_t *result);
uint8_t bin_to_tm1637_digit(uint8_t digit);

uint8_t half_byteH(uint8_t digit);
uint8_t half_byteL(uint8_t digit);

//========================================================
//		Преобразование 8-битного двоичного
//		значения в упакованный BCD формат
//========================================================
uint8_t bin8bcd(uint8_t byte)
{
    int16_t _byte = (int16_t)byte;
    uint8_t bcd_byte = 0;
    uint8_t digitL = 0;
    uint8_t digitH = 0;

    while(_byte > 0)
    {
	    _byte -= 10;
	    if(_byte >= 0)
			digitH++;
    }

    if(_byte < 0)
		digitL = _byte + 10;

    bcd_byte = (digitH << 4) | digitL;

    return bcd_byte;
}

//========================================================
//		Преобразование 8-битного упаковонного
//		значения в двоичный формат
//========================================================
uint8_t bcd8bin(uint8_t bcd_byte)
{
    uint8_t result = half_byteL(bcd_byte);
    uint8_t digitH = half_byteH(bcd_byte);

    while(result >= 10)
    {
	    result -= 10;
	    digitH++;
    }

    while(digitH > 0)
    {
	    result += 10;
	    digitH--;
    }

    return result;
}

//========================================================
//		Инкремент числа с заданными границами
//========================================================
uint8_t inc_circle(uint8_t digit, uint8_t min, uint8_t max)
{
	uint16_t _digit = (int16_t)digit;
	_digit++;
	
	if(_digit > max)
		_digit = min;
	
	return _digit;
}

//========================================================
//		Преобразование данных с ds1302 в
//		числа для 4-х сегментного дисплея tm1637
//=======================================================
void conv_ds1302_to_tm1637(uint8_t ds1302_digit,  uint8_t *result)
{
	result[0] = bin_to_tm1637_digit(half_byteL(ds1302_digit));
	result[1] = bin_to_tm1637_digit(half_byteH(ds1302_digit));
}

uint8_t bin_to_tm1637_digit(uint8_t digit)
{
	uint8_t result;
	switch (digit)
	{
	case 0:
		result = 0b00111111;
		break;
	case 1:
		result = 0b00000110;
		break;
	case 2:
		result = 0b01011011;
		break;
	case 0x03:
		result = 0b01001111;
		break;
	case 4:
		result = 0b01100110;
		break;
	case 5:
		result = 0b01101101;
		break;
	case 6:
		result = 0b01111101;
		break;
	case 7:
		result = 0b00000111;
		break;
	case 8:
		result = 0b01111111;
		break;
	case 9:
		result = 0b01101111;
		break;
	default:
		result = 0b01001001;
		break;
	}
	
	return result;
}

//========================================================
//		Вернуть старшие разряды байта
//		Пример: 0xab -> 0x0a
//=======================================================

uint8_t half_byteH(uint8_t digit)
{
	return ((digit & 0xf0) >> 4);
}

//========================================================
//		Вернуть младшие разряды байта
//		Пример: 0xab -> 0x0b
//=======================================================
uint8_t half_byteL(uint8_t digit)
{
	return (digit & 0x0f);
}