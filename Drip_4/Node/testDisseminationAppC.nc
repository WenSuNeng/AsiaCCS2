includes drip_msg;

configuration testDisseminationAppC {}
implementation {
	components testDisseminationC as App;

	components MainC;
	App.Boot -> MainC;

	components ActiveMessageC;
	App.RadioControl -> ActiveMessageC;

	components DisseminationC;
	App.DisseminationControl -> DisseminationC;

	components new DisseminatorC(drip_data2_t, 0x2345) as Data1Disseminator;

	App.Data1Value -> Data1Disseminator;

	components new DisseminatorC(drip_data2_t, 0x3456) as Data2Disseminator;
	App.Data2Value -> Data2Disseminator;

	components new DisseminatorC(drip_data2_t, 0x4567) as Data3Disseminator;
	App.Data3Value -> Data3Disseminator;

	components new DisseminatorC(drip_data2_t, 0x5678) as Data4Disseminator;
	App.Data4Value -> Data4Disseminator;

	components LedsC;
	App.Leds -> LedsC;

	components SerialActiveMessageC;
	App.SerialControl -> SerialActiveMessageC;
	App.Packet -> SerialActiveMessageC;
	App.AckSend -> SerialActiveMessageC.AMSend[AM_DRIP_ACK_MSG];
}
