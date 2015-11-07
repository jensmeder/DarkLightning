//
//  JMRootViewModel.m
//  DarkLightning
//
//  Created by Jens Meder on 06/11/15.
//  Copyright © 2015 Jens Meder. All rights reserved.
//

#import "JMRootViewModel.h"
#import <DarkLightning/JMSimpleDataPacketProtocol.h>

@interface JMRootViewModel () <JMMobileDevicePortDelegate>

@end

@implementation JMRootViewModel
{
	@private
	
	id<JMDataPacketProtocol> _packetProtocol;
}

-(instancetype)initWithDevicePort:(JMMobileDevicePort *)devicePort
{
	self = [super init];
	
	if (self)
	{
		_devicePort = devicePort;
		_devicePort.delegate = self;
		
		_packetProtocol = [[JMSimpleDataPacketProtocol alloc]init];
	}
	
	return self;
}

#pragma mark - Delegate

-(void)mobileDevicePort:(JMMobileDevicePort *)port didChangeState:(JMMobileDevicePortState)state
{
	if(state == JMMobileDevicePortStateConnected)
	{
		for (int i = 0; i < 50; i++)
		{
			NSData* data = [@"Hello" dataUsingEncoding:NSUTF8StringEncoding];
			
			[port writeData:[_packetProtocol encodePacket:data]];
		}
	}
	else
	{
		[_packetProtocol reset];
	}
}

-(void)mobileDevicePort:(JMMobileDevicePort *)port didReceiveData:(NSData *)data
{
	
}

@end
