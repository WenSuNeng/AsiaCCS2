
module testDisseminationC {
	uses interface Boot;
	uses interface SplitControl as RadioControl;
	uses interface StdControl as DisseminationControl;

	//uses interface DisseminationValue<drip_data2_t> as Data1Value;
	uses interface DisseminationUpdate<drip_data2_t> as Data1Update;

	//uses interface DisseminationValue<drip_data2_t> as Data2Value;
	uses interface DisseminationUpdate<drip_data2_t> as Data2Update;

	//uses interface DisseminationValue<drip_data2_t> as Data3Value;
	uses interface DisseminationUpdate<drip_data2_t> as Data3Update;

	//uses interface DisseminationValue<drip_data2_t> as Data4Value;
	uses interface DisseminationUpdate<drip_data2_t> as Data4Update;

	uses interface Leds;
	//uses interface Timer<TMilli> as DisseminationTimer;

	uses interface SplitControl as SerialControl;
	//uses interface AMSend as SerialSend;
	//uses interface Packet as SerialPacket;
	uses interface Receive as SerialReceive;
}

implementation {
	//message_t serial_packet;

	drip_data2_t data1;
	drip_data2_t data2;
	drip_data2_t data3;
	drip_data2_t data4;

	bool serialLocked = FALSE;

	event void Boot.booted() {
		memset((uint8_t *)(&data1), 0, 2);
		memset((uint8_t *)(&data2), 0, 2);
		memset((uint8_t *)(&data3), 0, 2);
		memset((uint8_t *)(&data4), 0, 2);

		call SerialControl.start();
	}

	event void RadioControl.startDone(error_t res) {
		if (res == SUCCESS) {
			call DisseminationControl.start();
		} else {
			call RadioControl.start();
		}
	}

	event void SerialControl.startDone(error_t err) {
		if (err == SUCCESS) {
			call RadioControl.start();
		} else {
			call SerialControl.start();
		}
	}

	event void RadioControl.stopDone(error_t err) { }

	event void SerialControl.stopDone(error_t err) { }

	/*event void SerialSend.sendDone (message_t *msg, error_t err) {
		if (&serial_packet == msg) {
			serialLocked = FALSE;
		}
	}*/
	
	event message_t *SerialReceive.receive(message_t *msg, void *payload, uint8_t len) {
		drip_msg_t *serialpkt = (drip_msg_t *)payload;
		//call Leds.led0Toggle();
		switch (serialpkt -> type) {
		case ID_DATA1:
			call Leds.led1Toggle();
			memcpy((uint8_t *)(&data1), (uint8_t *)(serialpkt->content), len - 1);
			call Data1Update.change(&data1);
			break;
		case ID_DATA2:
			memcpy((uint8_t *)(&data2), serialpkt->content, len - 1);
			call Data2Update.change(&data2);
			break;
		case ID_DATA3:
			memcpy((uint8_t *)(&data3), serialpkt->content, len - 1);
			call Data3Update.change(&data3);
			break;
		case ID_DATA4:
			memcpy((uint8_t *)(&data4), serialpkt->content, len - 1);
			call Data4Update.change(&data4);
			break;
		}
		
		return msg;
	}


	/*
	event void Data1Value.changed() {
		const drip_data2_t* newdata = (drip_data2_t *)(call Data1Value.get());

		call Leds.led1Toggle();

		memcpy(data1, newdata->data, 2);
	}

	event void Data2Value.changed() {
		const drip_data2_t* newdata = (drip_data2_t *)(call Data2Value.get());

		memcpy(data2, newdata->data, 2);
	}

	event void Data3Value.changed() {
		const drip_data2_t* newdata = (drip_data2_t *)(call Data3Value.get());

		memcpy(data3, newdata->data, 2);
	}

	event void Data4Value.changed() {
		const drip_data2_t* newdata = (drip_data2_t *)(call Data4Value.get());

		memcpy(data4, newdata->data, 2);
	}*/

}
