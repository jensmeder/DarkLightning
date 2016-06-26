//
//  usbmux_packet_tests.m
//  DarkLightning
//
//  Created by Jens Meder on 19/03/16.
//  Copyright © 2016 Jens Meder. All rights reserved.
//

@import Kiwi;
#import "usbmux_packet.h"

SPEC_BEGIN(usbmux_packet_tests)

it(@"should return zero of no packet has been provided", ^{
	
	uint32_t length = usbmux_packet_get_payload_size(NULL);
	[[theValue(length) should] beZero];
});

it(@"should return the payload size of a packet", ^{
	
	usbmux_packet_t packet = {140, USBMuxPacketProtocolPlist,USBMuxPacketTypeConnect,34,{}};
	uint32_t length = usbmux_packet_get_payload_size(&packet);
	
	[[theValue(length) should] equal:@(140-sizeof(usbmux_packet_t))];
});

SPEC_END
