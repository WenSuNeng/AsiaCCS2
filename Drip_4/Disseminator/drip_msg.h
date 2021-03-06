#ifndef DRIP_MSG_H
#define DRIP_MSG_H

enum {
	AM_SERIAL_MSG = 6,
	AM_DRIP_ACK_MSG = 7,
	DRIP_VERSION_UKNOWN = 0,
};

enum {
	ID_DATA1 = 1,
	ID_DATA2 = 2,
	ID_DATA3 = 3,
	ID_DATA4 = 4,
	ID_DATA5 = 5,
	ID_DATA6 = 6,
	ID_DATA7 = 7,
	ID_DATA8 = 8,
	ID_DATA9 = 9,
	ID_DATA10 = 10,
	ID_DATA11 = 11,
	ID_DATA12 = 12,
	ID_DATA13 = 13,
	ID_DATA14 = 14,
	ID_DATA15 = 15,
	ID_DATA16 = 16,
	ID_DATA17 = 17,
	ID_DATA18 = 18,
	ID_DATA19 = 19,
	ID_DATA20 = 20,
};

typedef nx_struct drip_msg
{
	nx_uint8_t type;
	nx_uint8_t content[0];
} drip_msg_t;

typedef nx_struct drip_data2
{
	nx_uint8_t data[2];
} drip_data2_t;

typedef nx_struct drip_data4
{
	nx_uint8_t data[4];
} drip_data4_t;

typedef nx_struct drip_data6
{
	nx_uint8_t data[6];
} drip_data6_t;

typedef nx_struct drip_data8
{
	nx_uint8_t data[8];
} drip_data8_t;

typedef nx_struct drip_ack_msg
{
	nx_uint8_t type;
	nx_uint8_t updated;
	nx_uint16_t id;
} drip_ack_msg_t;

#endif
