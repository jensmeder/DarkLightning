//
//  JMTaggedPacketTests.m
//  DarkLightning
//
//  Created by Jens Meder on 19/03/16.
//  Copyright © 2016 Jens Meder. All rights reserved.
//

@import Kiwi;
#import "JMTaggedPacket.h"

SPEC_BEGIN(JMTaggedPacketTests)

describe(@"JMTaggedPacket", ^{
	
	context(@"when initializing", ^{
		
		it(@"should be possible to create an instance without providing data", ^{
			
			JMTaggedPacket* packet = [[JMTaggedPacket alloc]initWithData:nil andTag:1234];
			[packet shouldNotBeNil];
		});
		
		it(@"should be possible to create an instance with data", ^{
			
			JMTaggedPacket* packet = [[JMTaggedPacket alloc]initWithData:[@"DarkLightning" dataUsingEncoding:NSUTF8StringEncoding] andTag:1234];
			[packet shouldNotBeNil];
		});
	});
});

SPEC_END
