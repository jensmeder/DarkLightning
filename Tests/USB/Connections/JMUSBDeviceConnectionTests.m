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
	
	context(@"when initializing without a device", ^{
		
		it(@"should not return an instance", ^{
			
			JMUSBDeviceConnection* connection = [[JMUSBDeviceConnection alloc]initWithDevice:nil andPort:1234];
			[connection shouldBeNil];
		});
	});
	
	context(@"when initializing with a device and port", ^{
		
		it(@"should return an instance", ^{
			
			JMUSBDevice* device = [KWMock nullMockForClass:[JMUSBDevice class]];
			JMUSBDeviceConnection* connection = [[JMUSBDeviceConnection alloc]initWithDevice:device andPort:1234];
			[connection shouldNotBeNil];
		});
	});
	
	context(@"when initializing with just a port", ^{
		
		it(@"should not return an instance", ^{
			
			JMUSBDeviceConnection* connection = [[JMUSBDeviceConnection alloc]initWithPort:1234];
			[connection shouldBeNil];
		});
	});
	
	context(@"when initializing with an invalid device", ^{
		
		it(@"should return nil", ^{
			
			JMUSBDeviceConnection* connection = [[JMUSBDeviceConnection alloc]initWithDevice:[JMUSBDevice invalidUSBDevice] andPort:1234];
			[connection shouldBeNil];
		});
	});
	
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
