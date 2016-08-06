//
//  usbmux_packet_tests.m
//  DarkLightning
//
//  Created by Jens Meder on 19/03/16.
//  Copyright © 2016 Jens Meder. All rights reserved.
//

@import XCTest;
#import "usbmux_packet.h"

@interface USBMuxPacketSpec : XCTestCase

@end

@implementation USBMuxPacketSpec

-(void) test_WHEN_usbmux_packet_get_payload_sizeWithNULL_THEN_itShouldReturnZero {
	
	uint32_t length = usbmux_packet_get_payload_size(NULL);
	
	XCTAssertTrue(length == 0);
}

-(void) test_WHEN_usbmux_packet_get_payload_sizeWithValidPacket_THEN_itShouldReturnSize {
	
	usbmux_packet_t packet = {140, USBMuxPacketProtocolPlist,USBMuxPacketTypeConnect,34,{}};
	uint32_t length = usbmux_packet_get_payload_size(&packet);
	
	XCTAssertTrue(length == 140-sizeof(usbmux_packet_t));
}

@end
