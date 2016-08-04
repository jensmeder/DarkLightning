//
//  JMUSBDeviceConnectionTests.m
//  DarkLightning
//
//  Created by Jens Meder on 19/03/16.
//  Copyright © 2016 Jens Meder. All rights reserved.
//

@import Kiwi;
#import "JMUSBDeviceConnection.h"

SPEC_BEGIN(JMUSBDeviceConnectionTests)

describe(@"JMUSBDeviceConnection", ^{
	
	context(@"when connect is called", ^{
		
		context(@"and connection is in disconnected state", ^{
			
			__block JMUSBDeviceConnection* connection = nil;
			
			beforeEach(^{
				
				JMUSBDevice* device = [KWMock nullMockForClass:[JMUSBDevice class]];
				connection = [[JMUSBDeviceConnection alloc]initWithDevice:device andPort:1234];
			});
			
			it(@"should return YES", ^{
				
				BOOL status = [connection connect];
				[[theValue(status) should] beYes];
			});
		});
	});
});

SPEC_END
