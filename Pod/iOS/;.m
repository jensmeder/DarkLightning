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

static const NSUInteger JMMobileDevicePortBufferSize = 2048;

@interface JMMobileDevicePort () <NSStreamDelegate>

@end

@implementation JMMobileDevicePort
{
	@private
	
	NSInputStream* _inputStream;
	NSOutputStream* _outputStream;
	
	CFSocketRef _socket;
	
	CFSocketNativeHandle _connectionHandle;
	NSData* _handle;
	NSRunLoop* _backgroundRunLoop;

	CFRunLoopSourceRef _socketsource;
}

-(instancetype)initWithPort:(uint32_t)port
{
	self = [super init];
	
	if (self)
	{
		_port = port;
	}
	
	return self;
}

void handleConnect(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void *data, void *info)
{
	JMMobileDevicePort* devicePort = (__bridge JMMobileDevicePort*)info;

	CFReadStreamRef readStream = NULL;
	CFWriteStreamRef writeStream = NULL;

	CFStreamCreatePairWithSocket(kCFAllocatorDefault, *(CFSocketNativeHandle *)data, &readStream, &writeStream);

	devicePort->_inputStream = (__bridge NSInputStream *)(readStream);
	devicePort->_outputStream = (__bridge NSOutputStream *)(writeStream);

	CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
	CFWriteStreamSetProperty(writeStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);

	devicePort->_inputStream.delegate = devicePort;
	devicePort->_outputStream.delegate = devicePort;

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),
	^{
		devicePort->_backgroundRunLoop = [NSRunLoop currentRunLoop];
		[devicePort->_inputStream scheduleInRunLoop:devicePort->_backgroundRunLoop forMode:NSDefaultRunLoopMode];
		[devicePort->_outputStream scheduleInRunLoop:devicePort->_backgroundRunLoop forMode:NSDefaultRunLoopMode];

		[devicePort->_inputStream open];
		[devicePort->_outputStream open];

		[devicePort->_backgroundRunLoop run];
	});
}

-(void)open
{
		CFSocketContext context = { 0, (__bridge void *)(self), NULL, NULL, NULL };

		_socket = CFSocketCreate(
								 kCFAllocatorDefault,
								 PF_INET,
								 SOCK_STREAM,
								 IPPROTO_TCP,
								 kCFSocketAcceptCallBack, handleConnect, &context);

		struct sockaddr_in sin;

		memset(&sin, 0, sizeof(sin));
		sin.sin_len = sizeof(sin);
		sin.sin_family = AF_INET;
		sin.sin_port = htons(_port);
		sin.sin_addr.s_addr= htonl(INADDR_LOOPBACK);

		CFDataRef sincfd = CFDataCreate(
										kCFAllocatorDefault,
										(UInt8 *)&sin,
										sizeof(sin));

		CFSocketSetAddress(_socket, sincfd);
		CFRelease(sincfd);

		// Start Listening

		_socketsource = CFSocketCreateRunLoopSource(
																	  kCFAllocatorDefault,
																	  _socket,
																	  0);

		CFRunLoopAddSource(
						   CFRunLoopGetMain(),
						   _socketsource,
						   kCFRunLoopDefaultMode);

	self.state = JMMobileDevicePortStateWaitingForConnection;
}

-(void)close
{
	_inputStream.delegate = nil;
	_outputStream.delegate = nil;
	
	[_inputStream close];
	[_outputStream close];
	
	[_inputStream removeFromRunLoop:_backgroundRunLoop forMode:NSDefaultRunLoopMode];
	[_outputStream removeFromRunLoop:_backgroundRunLoop forMode:NSDefaultRunLoopMode];

	_backgroundRunLoop = nil;
	
	_inputStream = nil;
	_outputStream = nil;

	CFRunLoopRemoveSource(CFRunLoopGetMain(), _socketsource, kCFRunLoopDefaultMode);
	_socketsource = NULL;
	self.state = JMMobileDevicePortStateIdle;




}

-(BOOL)writeData:(NSData *)data
{
	if (!data || _state != JMMobileDevicePortStateConnected)
	{
		return NO;
	}
	
	NSInteger bytesWritten = [_outputStream write:data.bytes maxLength:data.length];
	if (bytesWritten)
	{
		return YES;
	}

	return NO;
}

#pragma mark - Internal

-(void)setState:(JMMobileDevicePortState)state
{
	_state = state;

	if ([_delegate respondsToSelector:@selector(mobileDevicePort:didChangeState:)])
	{
		[_delegate mobileDevicePort:self didChangeState:_state];
	}
}

#pragma mark - Stream Delegate

-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
	if(eventCode == NSStreamEventHasBytesAvailable)
	{
		uint8_t buffer[JMMobileDevicePortBufferSize];
	
		NSMutableData* output = [NSMutableData data];
		
		while (_inputStream.hasBytesAvailable)
		{
			NSInteger bytesRead = [_inputStream read:buffer maxLength:JMMobileDevicePortBufferSize];
			
			if (bytesRead > 0)
			{
				[output appendBytes:buffer length:bytesRead];
			}
		}
		
		if (output.length > 0 && [_delegate respondsToSelector:@selector(mobileDevicePort:didReceiveData:)])
		{
			[_delegate mobileDevicePort:self didReceiveData:output];
		}
	}
	else if(eventCode == NSStreamEventEndEncountered)
	{
		if (aStream.streamStatus == NSStreamStatusClosed || aStream.streamStatus == NSStreamStatusAtEnd)
		{
			self.state = JMMobileDevicePortStateWaitingForConnection;

			[self close];
			[self open];
		}
	}
	else if(eventCode == NSStreamEventErrorOccurred)
	{
		[self close];
	}
	else if(eventCode == NSStreamEventHasSpaceAvailable)
	{
		if (_state != JMMobileDevicePortStateConnected && _inputStream.streamStatus == NSStreamStatusOpen && _outputStream.streamStatus == NSStreamStatusOpen)
		{
			self.state = JMMobileDevicePortStateConnected;
		}
	}
}

@end
