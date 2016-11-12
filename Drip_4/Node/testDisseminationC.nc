
module testDisseminationC {
	uses interface Boot;
	uses interface SplitControl as RadioControl;
	uses interface StdControl as DisseminationControl;

	uses interface DisseminationValue<drip_data2_t> as Data1Value;

	uses interface DisseminationValue<drip_data2_t> as Data2Value;

	uses interface DisseminationValue<drip_data2_t> as Data3Value;

	uses interface DisseminationValue<drip_data2_t> as Data4Value;

	uses interface Leds;

	uses interface SplitControl as SerialControl;
	uses interface AMSend as AckSend;
	uses interface Packet;
}

implementation {
	message_t packet;

	uint8_t data1[2];
	uint8_t data2[2];
	uint8_t data3[2];
	uint8_t data4[2];

	uint8_t updated = 0;

	bool serialLocked = FALSE;

	void sendAck(uint8_t type, uint8_t updated_seq, uint16_t id) {
		drip_ack_msg_t *ackpkt;
		if (serialLocked) {
			return;
		}
		ackpkt = (drip_ack_msg_t *)(call Packet.getPayload(&packet, sizeof(drip_ack_msg_t)));
		if (ackpkt == NULL) {
			return;
		}
		ackpkt->type = type;
		ackpkt->updated = updated_seq;
		ackpkt->id = id;
		if (call AckSend.send(AM_BROADCAST_ADDR, &packet, sizeof(drip_ack_msg_t)) == SUCCESS) {
			serialLocked = TRUE;
		}
	}

	event void Boot.booted() {
		memset(data1, 0, 2);
		memset(data2, 0, 2);
		memset(data3, 0, 2);
		memset(data4, 0, 2);

		call RadioControl.start();
	}

	event void RadioControl.startDone(error_t res) {
		if (res == SUCCESS) {
			call SerialControl.start();
		} else {
			call RadioControl.start();
		}
	}

	event void RadioControl.stopDone(error_t err) { }

	event void SerialControl.startDone(error_t error) {
		if (error == SUCCESS) {
			call DisseminationControl.start();
		} else {
			call SerialControl.start();
		}
	}

	event void SerialControl.stopDone(error_t error) { }

	event void AckSend.sendDone (message_t *msg, error_t err) {
		if (&packet == msg) {
			call Leds.led0Toggle();
			serialLocked = FALSE;
		}
	}

	event void Data1Value.changed() {
		const drip_data2_t* newdata = (drip_data2_t *)(call Data1Value.get());

		call Leds.led1Toggle();

		memcpy(data1, newdata->data, 2);

		updated++;

		if (updated == DATA_NUM) {
			sendAck(ID_DATA1, updated, TOS_NODE_ID);
			call Leds.led2Toggle();
			updated = 0;
		}
	}

	event void Data2Value.changed() {
		const drip_data2_t* newdata = (drip_data2_t *)(call Data2Value.get());

		call Leds.led1Toggle();
		
		memcpy(data2, newdata->data, 2);
		updated++;
		
		if (updated == DATA_NUM) {
			sendAck(ID_DATA2, updated, TOS_NODE_ID);
			call Leds.led2Toggle();
			updated = 0;
		}
	}

	event void Data3Value.changed() {
		const drip_data2_t* newdata = (drip_data2_t *)(call Data3Value.get());

		call Leds.led1Toggle();
		
		memcpy(data3, newdata->data, 2);
		updated++;
		
		if (updated == DATA_NUM) {
			sendAck(ID_DATA3, updated, TOS_NODE_ID);
			call Leds.led2Toggle();
			updated = 0;
		}
	}

	event void Data4Value.changed() {
		const drip_data2_t* newdata = (drip_data2_t *)(call Data4Value.get());

		call Leds.led1Toggle();

		memcpy(data4, newdata->data, 2);
		updated++;
		
		if (updated == DATA_NUM) {
			sendAck(ID_DATA4, updated, TOS_NODE_ID);
			call Leds.led2Toggle();
			updated = 0;
		}
	}

}
