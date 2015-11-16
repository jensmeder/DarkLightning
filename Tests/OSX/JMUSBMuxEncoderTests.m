//
//  JMUSBMuxEncoderTests.m
//  DarkLightning
//
//  Created by Jens Meder on 16/11/15.
//  Copyright © 2015 Jens Meder. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "JMUSBMuxEncoder.h"

SPEC_BEGIN(JMUSBMuxEncoderTests)

describe(@"JMUSBMuxEncoder",
^{
	context(@"when initializing",
	^{
		it(@"should return nil",
		^{
			JMUSBMuxEncoder* encoder = [[JMUSBMuxEncoder alloc]init];
								
			[[encoder should] beNil];
		});
	});
	
	context(@"when requesting connect packet",
	^{
		it(@"should return nil if device id is nil",
		^{
			NSData* data = [JMUSBMuxEncoder encodeConnectPacketForDeviceId:nil andPort:1234];
								
			[[data should] beNil];
		});
		
		it(@"should return a packet if device id is a valid NSNumber object",
		^{
			NSData* data = [JMUSBMuxEncoder encodeConnectPacketForDeviceId:@1 andPort:1234];
			   
			[[data shouldNot] beNil];
		});
	});
});

SPEC_END
