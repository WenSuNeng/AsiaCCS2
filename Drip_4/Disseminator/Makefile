COMPONENT=testDisseminationAppC

### For Drip:
CFLAGS += -I$(TOSDIR)/lib/net -I%T/lib/net/drip
#CFLAGS += -DTOSH_DATA_LENGTH=60
#CFLAGS += -DCC2420_DEF_CHANNEL=17
CFLAGS += -DCC2420_DEF_RFPOWER=3

BUILD_EXTRA_DEPS = drip_ack_msg.c
CLEAN_EXTRA = drip_ack_msg.h drip_ack_msg.h

drip_ack_msg.c: drip_msg.h
	mig c -target=$(PLATFORM) $(CFLAGS) drip_msg.h drip_ack_msg -o drip_ack_msg.h

include $(MAKERULES)

