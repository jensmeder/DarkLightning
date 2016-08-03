/**
 *	The MIT License (MIT)
 *
 *	Copyright (c) 2015 Jens Meder
 *
 *	Permission is hereby granted, free of charge, to any person obtaining a copy of
 *	this software and associated documentation files (the "Software"), to deal in
 *	the Software without restriction, including without limitation the rights to
 *	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 *	the Software, and to permit persons to whom the Software is furnished to do so,
 *	subject to the following conditions:
 *
 *	The above copyright notice and this permission notice shall be included in all
 *	copies or substantial portions of the Software.
 *
 *	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 *	FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 *	COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 *	IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 *	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "JMPathSocket.h"
#import <netinet/in.h>
#import <sys/socket.h>
#import <sys/ioctl.h>
#import <sys/un.h>
#import <err.h>

@implementation JMPathSocket
{
	@private
	
	dispatch_fd_t 		_socketHandle;
}

@synthesize inputStream = _inputStream;
@synthesize outputStream = _outputStream;
@synthesize state = _state;

-(instancetype)initWithPath:(NSString *)path
{
	self = [super init];
	
	if (self) {
		
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
		return YES;
	}
	
	self.state = JMSocketStateDisconnected;
	
	[_inputStream close];
	[_outputStream close];
	
	_inputStream = nil;
	_outputStream = nil;
	
	close(_socketHandle);
	
	return YES;
}

-(BOOL)isEqual:(id)object {
	
	BOOL isEqual = NO;
	
	if ([object isKindOfClass:[JMPathSocket class]]) {
		
		JMPathSocket* obj = object;
		isEqual = [obj.path isEqualToString:_path];
	}
	
	return isEqual;
}

#pragma mark - Properties

-(void) setState:(JMSocketState)state
{
	_state = state;
}

@end
