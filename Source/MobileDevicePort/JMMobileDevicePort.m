/**
 *	JMMobileDevicePort.m
 * 	DarkLightning
 *
 *
 *
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

#import "JMMobileDevicePort.h"
#import <CoreFoundation/CoreFoundation.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import "JMSocketConnection.h"
#import "JMNativeSocket.h"

@interface JMMobileDevicePort () <JMSocketConnectionDelegate>

@end

@implementation JMMobileDevicePort
{
	@private
	
	JMSocketConnection* _connection;
	
	CFSocketRef _socket;
	CFRunLoopSourceRef _socketSource;
	NSRunLoop* _backgroundRunLoop;
}

-(instancetype)initWithPort:(uint32_t)port
{
	self = [super init];
	
	if (self)
	{
		_port = port;
		_state = JMMobileDevicePortStateIdle;
	}
	
	return self;
}

void handleConnect(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void *data, void *info)
{
	JMMobileDevicePort* devicePort = (__bridge JMMobileDevicePort*)info;

	JMNativeSocket* socket = [[JMNativeSocket alloc]initWithNativeSocket:*(CFSocketNativeHandle *)data];
	devicePort->_connection = [[JMSocketConnection alloc]initWithSocket:socket];
	devicePort->_connection.delegate = devicePort;
	
	[devicePort->_connection connect];
}

-(BOOL)open
{
	if (_state != JMMobileDevicePortStateIdle)
	{
		return YES;
	}
	
	self.state = JMMobileDevicePortStateOpening;

	CFSocketContext context = { 0, (__bridge void *)(self), NULL, NULL, NULL };

	_socket = CFSocketCreate(	kCFAllocatorDefault,
								PF_INET,
								SOCK_STREAM,
								IPPROTO_TCP,
								kCFSocketAcceptCallBack, handleConnect, &context);
	
	if (!_socket)
	{
		self.state = JMMobileDevicePortStateIdle;
		
		return NO;
	}

	struct sockaddr_in sin;

	memset(&sin, 0, sizeof(sin));
	sin.sin_len = sizeof(sin);
	sin.sin_family = AF_INET;
	sin.sin_port = htons(_port);
	sin.sin_addr.s_addr= htonl(INADDR_LOOPBACK);

	CFDataRef sincfd = CFDataCreate(kCFAllocatorDefault,
									(UInt8 *)&sin,
									sizeof(sin));
	// Reuse address and port

	int reuseAddress = true;
	setsockopt(CFSocketGetNative(_socket), SOL_SOCKET, SO_REUSEADDR, (void *)&reuseAddress, sizeof(reuseAddress));

	int reusePort = true;
	setsockopt(CFSocketGetNative(_socket), SOL_SOCKET, SO_REUSEPORT, (const char*)&reusePort, sizeof(reusePort));

	CFSocketSetAddress(_socket, sincfd);
	CFRelease(sincfd);

	// Start Listening

	_socketSource = CFSocketCreateRunLoopSource(	kCFAllocatorDefault,
													_socket,
													0);

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),
	^{
		_backgroundRunLoop = [NSRunLoop currentRunLoop];
		
		CFRunLoopAddSource(
						   _backgroundRunLoop.getCFRunLoop,
						   _socketSource,
						   kCFRunLoopDefaultMode);
		self.state = JMMobileDevicePortStateWaitingForConnection;
		[_backgroundRunLoop run];
	});
	
	return YES;
}

-(BOOL)close
{
	if (_state == JMMobileDevicePortStateIdle)
	{
		return YES;
	}

	[_connection disconnect];

	if (_socketSource)
	{
		CFRunLoopRemoveSource(_backgroundRunLoop.getCFRunLoop, _socketSource, kCFRunLoopDefaultMode);
		_socketSource = NULL;
	}
	
	if (_socket)
	{
		CFSocketInvalidate(_socket);
		CFRelease(_socket);
		_socket = nil;
	}
	
	_backgroundRunLoop = nil;

	self.state = JMMobileDevicePortStateIdle;
	
	return YES;
}

-(BOOL)writeData:(NSData *)data
{
	if (!data || data.length == 0 ||  _state != JMMobileDevicePortStateConnected)
	{
		return NO;
	}

	return [_connection writeData:data];
}

#pragma mark - Internal

-(void)setState:(JMMobileDevicePortState)state
{
	_state = state;

	if ([_delegate respondsToSelector:@selector(mobileDevicePort:didChangeState:)])
	{
		dispatch_async(dispatch_get_main_queue(),
		^{
			[_delegate mobileDevicePort:self didChangeState:_state];
		});
		
	}
}

#pragma mark - Stream Delegate

-(void)connection:(JMSocketConnection *)connection didChangeState:(JMSocketConnectionState)state
{
	if (state == JMSocketStateConnected)
	{
		self.state = JMMobileDevicePortStateConnected;
	}
	else
	{
		self.state = JMMobileDevicePortStateWaitingForConnection;
	}
}

-(void)connection:(JMSocketConnection *)connection didFailToConnect:(NSError *)error
{
	
}

-(void)connection:(JMSocketConnection *)connection didReceiveData:(NSData *)data
{
	dispatch_async(dispatch_get_main_queue(),
	^{
		[_delegate mobileDevicePort:self didReceiveData:data];
	});
}

@end
