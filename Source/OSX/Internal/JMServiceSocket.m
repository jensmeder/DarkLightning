//
//  JMServiceSocket.m
//  DarkLightning
//
//  Created by Jens Meder on 18/11/15.
//  Copyright © 2015 Jens Meder. All rights reserved.
//

#import "JMServiceSocket.h"
#import <netinet/in.h>
#import <sys/socket.h>
#import <sys/ioctl.h>
#import <sys/un.h>
#import <err.h>

@implementation JMServiceSocket
{
	@private
	
	dispatch_fd_t 		_socketHandle;
}

@synthesize inputStream = _inputStream;
@synthesize outputStream = _outputStream;
@synthesize state = _state;

-(instancetype)initWithPath:(NSString *)path
{
	if (!path)
	{
		return nil;
	}
	
	self = [super init];
	
	if (self)
	{
		_path = path;
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
	// Create socket
	
	_socketHandle = socket(AF_UNIX, SOCK_STREAM, 0);
	if (_socketHandle == -1)
	{
		self.state = JMSocketStateDisconnected;
		
		return NO;
	}
	
	// Prevent SIGPIPE
	
	int on = 1;
	setsockopt(_socketHandle, SOL_SOCKET, SO_NOSIGPIPE, &on, sizeof(on));
	
	
	// Reuse address and port
	
	int reuseAddress = true;
	setsockopt(_socketHandle, SOL_SOCKET, SO_REUSEADDR, (void *)&reuseAddress, sizeof(reuseAddress));
	
	int reusePort = true;
	setsockopt(_socketHandle, SOL_SOCKET, SO_REUSEPORT, (const char*)&reusePort, sizeof(reusePort));
	
	// Connect socket
	
	struct sockaddr_un addr;
	memset(&addr, 0, sizeof(addr));
	addr.sun_family = AF_UNIX;
	strcpy(addr.sun_path, [self.path cStringUsingEncoding:NSUTF8StringEncoding]);
	socklen_t socklen = sizeof(addr);
	
	if (connect(_socketHandle, (struct sockaddr*)&addr, socklen) == -1)
	{
		self.state = JMSocketStateDisconnected;
		
		return NO;
	}

	CFReadStreamRef readStream;
	CFWriteStreamRef writeStream;
	
	CFStreamCreatePairWithSocket(kCFAllocatorDefault, _socketHandle, &readStream, &writeStream);
	
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
	
	close(_socketHandle);
	
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
