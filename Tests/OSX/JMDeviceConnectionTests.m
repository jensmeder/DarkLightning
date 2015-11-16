//
//  JMDeviceConnectionTests.m
//  DarkLightning
//
//  Created by Jens Meder on 16/11/15.
//  Copyright © 2015 Jens Meder. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "JMDeviceConnection.h"

SPEC_BEGIN(JMDeviceConnectionTests)

describe(@"JMUSBDevice",
^{
	context(@"when initializing",
	^{
		it(@"should return nil when initializing without port",
		^{
			JMDeviceConnection* connection = [[JMDeviceConnection alloc]init];
			
			[[connection should] beNil];
		});
		
		it(@"should return nil when initializing with a port",
		   ^{
			   JMDeviceConnection* connection = [[JMDeviceConnection alloc]initWithPort:1234];
			   
			   [[connection should] beNil];
		   });
	});
});

SPEC_END
