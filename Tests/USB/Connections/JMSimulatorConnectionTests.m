//
//  JMSimulatorConnectionTests.m
//  DarkLightning
//
//  Created by Jens Meder on 19/03/16.
//  Copyright © 2016 Jens Meder. All rights reserved.
//

@import Kiwi;
#import "JMSimulatorConnection.h"

SPEC_BEGIN(JMSimulatorConnectionTests)

describe(@"JMSimulatorConnection", ^{
	
	context(@"when calling connect", ^{
		
		__block JMDeviceConnection* connection = nil;
		
		beforeEach(^{
			
			connection = [[JMSimulatorConnection alloc]initWithPort:1234];
		});
		
		context(@"and connection is in disconnected state", ^{
			
			it(@"should return YES", ^{
				
				BOOL status = [connection connect];
				[[theValue(status) should] beYes];
			});
		});
	});
});

SPEC_END
