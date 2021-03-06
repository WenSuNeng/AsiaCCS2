#include <stdio.h>
#include <sys/time.h>
#include <message.h>
#include "serialsource.h"
#include "serialpacket.h"
#include "serialprotocol.h"

#include "drip_msg.h"
#include "drip_ack_msg.h"

int getNodeIdx(uint16_t nid, uint16_t *node, int num, int *updated)
{
	int i = 0;
	for (; i < num; i++)
	{
		if (node[i] == nid) {
			return i;
		}
	}
	return -1;
}


int main(int argc, char **argv)
{
	serial_source port;
	if (argc < 3)
	{
		printf("Usage: %s <device> <rate> <bytes> - send a raw packet to a serial port\n", argv[0]);
		exit(2);
	}
	port = open_serial_source(argv[1], platform_baud_rate(argv[2]), 0, NULL);

	if (port == NULL)
	{
		printf("Couldn't open serial port at %s:%s\n", argv[1], argv[2]);
		exit(1);
	}

	struct timeval tvend;
	int mlen;

	//printf("Data format(<ID, Updated, Type>:second:usecond)\n");

	while (1) {
		uint8_t *packet = (uint8_t *)read_serial_packet(port, &mlen);
		if (packet == NULL)
		{
			break;
		}
		gettimeofday(&tvend, NULL);
		uint8_t *pp = (uint8_t *)packet;
		tmsg_t *mmsg = new_tmsg(packet + 8, mlen - 8);

		printf("%d:%d:%d:%ld:%ld\n", drip_ack_msg_id_get(mmsg), drip_ack_msg_updated_get(mmsg), drip_ack_msg_type_get(mmsg), tvend.tv_sec, tvend.tv_usec);

		if (drip_ack_msg_updated_get(mmsg) == DATA_NUM)
		{
			free_tmsg(mmsg);
			break;
		}
		
		free_tmsg(mmsg);
	}
	
	close_serial_source(port);
	return 0;
}
