//
//  JMNativeSocket.m
//  DarkLightning
//
//  Created by Jens Meder on 20/11/15.
//  Copyright © 2015 Jens Meder. All rights reserved.
//

#import "JMNativeSocket.h"

@implementation JMNativeSocket

@synthesize inputStream = _inputStream;
@synthesize outputStream = _outputStream;
@synthesize state = _state;

-(instancetype)initWithNativeSocket:(CFSocketNativeHandle)nativeSocket
{
	self = [super init];
	
	if (self)
	{
		_nativeSocket = nativeSocket;
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
	
	CFStreamCreatePairWithSocket(kCFAllocatorDefault, _nativeSocket, &readStream, &writeStream);
	
	CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
	CFWriteStreamSetProperty(writeStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
	
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
	
	[_inputStream close];
	[_outputStream close];
	
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
