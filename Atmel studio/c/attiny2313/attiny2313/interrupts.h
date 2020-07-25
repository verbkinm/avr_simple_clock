#pragma once

ISR(INT0_vect)
{
	clock_mode = 0;
	DS1302_clock_off();

	if(++mode > 5)	
	{
		mode = 0;
		clock_mode = 0;
		DS1302_clock_on();
		if(bcd8bin(DS1302_get_day()) > max_day_month())
			DS1302_set_day(bin8bcd(max_day_month()));
	}
}

ISR(INT1_vect)
{
	if(mode == 0)
	{
		clock_mode = inc_circle(clock_mode, 0, 2);
		display_clock_mode();
	}
	if(mode == 1)
	{
		uint8_t buf = bcd8bin(DS1302_get_hours());
		buf = inc_circle(buf, 0, 23);
		DS1302_set_hours(bin8bcd(buf));
	}
	if(mode == 2)
	{
		uint8_t buf = bcd8bin(DS1302_get_minutes());
		buf = inc_circle(buf, 0, 59);
		DS1302_set_minutes(bin8bcd(buf));
	}
	if(mode == 3)
	{
		uint8_t buf = bcd8bin(DS1302_get_day());
		buf = inc_circle(buf, 1, max_day_month());
		DS1302_set_day(bin8bcd(buf));
	}
	if(mode == 4)
	{
		uint8_t buf = bcd8bin(DS1302_get_month());
		buf = inc_circle(buf, 1, 12);
		DS1302_set_month(bin8bcd(buf));
	}
	if(mode == 5)
	{
		uint8_t buf = bcd8bin(DS1302_get_year());
		buf = inc_circle(buf, 0, 99);
		DS1302_set_year(bin8bcd(buf));
		
	}
	read_package_data_from_ds1302();
}

ISR(TIMER1_COMPA_vect)
{
	read_package_data_from_ds1302();
	
	//!!switch - больше памяти
	if(mode == 0)
		display_clock_mode();
	else if(mode == 1)
	{
		TIME.minute[0] |= 0x80;
		display_mode(TIME.hour[1], TIME.hour[0], TIME.minute[1], TIME.minute[0], 0);
	}
	else if(mode == 2)
	{
		TIME.minute[0] |= 0x80;
		display_mode(TIME.hour[1], TIME.hour[0], TIME.minute[1], TIME.minute[0], 1);
	}
	else if(mode == 3)
	{
		DATE.day[0] |= 0x80;
		display_mode(DATE.day[1], DATE.day[0], DATE.month[1], DATE.month[0], 0);
	}
	else if(mode == 4)
	{
		DATE.day[0] |= 0x80;
		display_mode(DATE.day[1], DATE.day[0], DATE.month[1], DATE.month[0], 1);
	}
	else if(mode == 5)
		display_mode(DATE.yearH[1], DATE.yearH[0], DATE.yearL[1], DATE.yearL[0], 2);
}
