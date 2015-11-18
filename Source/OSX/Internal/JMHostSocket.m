//
//  JMHostSocket.m
//  DarkLightning
//
//  Created by Jens Meder on 18/11/15.
//  Copyright © 2015 Jens Meder. All rights reserved.
//

#import "JMHostSocket.h"

@implementation JMHostSocket

@synthesize inputStream = _inputStream;
@synthesize outputStream = _outputStream;
@synthesize state = _state;

-(instancetype)initWithHost:(NSString *)host andPort:(uint32_t)port
{
	if (!host)
	{
		return nil;
	}
	
	self = [super init];
	
	if (self)
	{
		_host = host;
		_port = port;
	}
	
	return self;
}

-(BOOL)connect
{
	if (self.state != JMSocketStateDisconnected)
	{
		return NO;
	}
	
	self.state = JMSocketStateConnecting;
	
	CFReadStreamRef readStream;
	CFWriteStreamRef writeStream;
	
	CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (__bridge CFStringRef) self.host, self.port, &readStream, &writeStream);
	
	_inputStream = (__bridge NSInputStream *)(readStream);
	_outputStream = (__bridge NSOutputStream *)(writeStream);
	
	self.state = JMSocketStateConnected;
	
	return YES;
}

-(BOOL)disconnect
{
	if (self.state == JMSocketStateDisconnected)
	{
		return NO;
	}
	
	self.state = JMSocketStateDisconnected;
	
	_inputStream = nil;
	_outputStream = nil;
	
	return YES;
}

#pragma mark - Properties

-(void) setState:(JMSocketState)state
{
	if (state == _state)
	{
		return;
	}
	
	_state = state;
}

@end
