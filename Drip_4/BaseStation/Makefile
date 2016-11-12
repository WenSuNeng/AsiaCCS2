disseminator: BaseStation.c drip_ack_msg.c
	gcc BaseStation.c drip_ack_msg.c -o disseminator -I/opt/tinyos-2.1.1/support/sdk/c/sf -L /opt/tinyos-2.1.1/support/sdk/c/sf -lmote -I /usr/include/openssl -L /usr/lib -lssl -lcrypto

clean:
	rm -f *.o disseminator receiver
