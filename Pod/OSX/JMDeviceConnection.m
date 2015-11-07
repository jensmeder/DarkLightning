//
//  JMDeviceConnection.m
//  Pods
//
//  Created by Jens Meder on 07/11/15.
//
//

#import "JMDeviceConnection.h"

@implementation JMDeviceConnection

-(instancetype)initWithPort:(uint32_t)port
{
	self = [super init];
	
	if (self)
	{
		_port = port;
	}
	
	return self;
}

-(void)connect
{
	
}

-(void)disconnect
{
	
}

-(BOOL)writeData:(NSData *)data
{
	return NO;
}

@end
