//
//  JMSocketMock.m
//  DarkLightning
//
//  Created by Jens Meder on 18/11/15.
//  Copyright © 2015 Jens Meder. All rights reserved.
//

#import "JMSocketMock.h"

@implementation JMSocketMock

@synthesize state = _state;
@synthesize inputStream = _inputStream;
@synthesize outputStream = _outputStream;

-(void) setState:(JMSocketState)state
{
	if (state != _state)
	{
		return;
	}
	
	_state = state;
}

-(BOOL)connect
{
	self.state = JMSocketStateConnecting;
	
	NSData* data = [@"Hello World" dataUsingEncoding:NSUTF8StringEncoding];
	_inputStream = [NSInputStream inputStreamWithData:data];
	_outputStream = [NSOutputStream outputStreamToMemory];
	
	self.state = JMSocketStateConnected;
	
	return YES;
}

-(BOOL)disconnect
{
	_inputStream = nil;
	_outputStream = nil;
	
	self.state = JMSocketStateDisconnected;
	
	return YES;
}

@end
