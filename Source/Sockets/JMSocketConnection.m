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

#import "JMSocketConnection.h"

static NSUInteger JMSocketConnectionBufferSize	= 1 << 16;

@interface JMSocketConnection () <NSStreamDelegate>

@end

@implementation JMSocketConnection
{
	@private
	
	NSRunLoop* _backgroundRunLoop;
}

-(instancetype)initWithSocket:(id<JMSocket>)socket
{
	if (!socket)
	{
		return nil;
	}
	
	self = [super init];
	
	if (self)
	{
		_socket = socket;
		_connectionState = JMSocketConnectionStateDisconnected;
	}
	
	return self;
}

-(BOOL)connect
{
	if (self.connectionState == JMSocketStateConnected)
	{
		return NO;
	}
	
	if (![_socket connect])
	{
		return NO;
	}
	
	self.connectionState = JMSocketStateConnecting;
	
	_socket.inputStream.delegate = self;
	_socket.outputStream.delegate = self;
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),
	^{
		_backgroundRunLoop = [NSRunLoop currentRunLoop];
		[_socket.inputStream scheduleInRunLoop:_backgroundRunLoop forMode:NSDefaultRunLoopMode];
		[_socket.outputStream scheduleInRunLoop:_backgroundRunLoop forMode:NSDefaultRunLoopMode];
					   
		[_socket.inputStream open];
		[_socket.outputStream open];
					   
		[_backgroundRunLoop run];
					   
	});
	
	return YES;
}

-(BOOL)disconnect
{
	if (self.connectionState == JMSocketConnectionStateDisconnected)
	{
		return YES;
	}
	
	_socket.inputStream.delegate = nil;
	_socket.outputStream.delegate = nil;
	
	[_socket.inputStream removeFromRunLoop:_backgroundRunLoop forMode:NSDefaultRunLoopMode];
	[_socket.outputStream removeFromRunLoop:_backgroundRunLoop forMode:NSDefaultRunLoopMode];
	
	[_socket.inputStream close];
	[_socket.outputStream close];
	
	_backgroundRunLoop = nil;
	
	self.connectionState = JMSocketConnectionStateDisconnected;
	
	return [_socket disconnect];
}


-(BOOL)writeData:(NSData *)data
{
	if (!data || data.length == 0 || _connectionState != JMSocketConnectionStateConnected) {
		
		return NO;
	}

	NSInteger bytesWritten = [_socket.outputStream write:data.bytes maxLength:data.length];

	while (bytesWritten != (NSInteger)data.length) {

		@autoreleasepool {
			
			NSData* subData = [data subdataWithRange:NSMakeRange(bytesWritten, data.length-bytesWritten)];
			bytesWritten += [_socket.outputStream write:subData.bytes maxLength:subData.length];
		}
	}
	
	if(bytesWritten > 0)
	{
		return YES;
	}
	
	return NO;
}
-(BOOL)isEqual:(id)object {
	
	BOOL isEqual = NO;
	
	if ([object isKindOfClass:[JMSocketConnection class]]) {
		
		JMSocketConnection* obj = object;
		isEqual = [_socket isEqual:obj.socket];
	}
	
	return isEqual;
}

#pragma mark - Properties

-(void)setConnectionState:(JMSocketConnectionState)connectionState
{
	if (connectionState == _connectionState)
	{
		return;
	}
	
	_connectionState = connectionState;
	
	if ([_delegate respondsToSelector:@selector(connection:didChangeState:)])
	{
		[_delegate connection:self didChangeState:_connectionState];
	}
}

#pragma mark - Stream Delegate

-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{

		if (self.connectionState != JMSocketConnectionStateConnected &&
			eventCode == NSStreamEventHasSpaceAvailable &&
			aStream.streamStatus == NSStreamStatusOpen)
		{
			self.connectionState = JMSocketConnectionStateConnected;
		}
		else if(eventCode == NSStreamEventHasBytesAvailable)
		{
			NSMutableData* data = [NSMutableData data];
			uint8_t buffer[JMSocketConnectionBufferSize];
						   
			while (_socket.inputStream.hasBytesAvailable)
			{
				NSInteger length = [_socket.inputStream read:buffer maxLength:JMSocketConnectionBufferSize];
				[data appendBytes:buffer length:length];
			}
						   
			if (!data.length)
			{
				return;
			}
						   
			if ([_delegate respondsToSelector:@selector(connection:didReceiveData:)])
			{
				[_delegate connection:self didReceiveData:data];
			}
		}
		else if (eventCode == NSStreamEventEndEncountered)
		{
			[self disconnect];
		}
		else if(eventCode == NSStreamEventErrorOccurred && self.connectionState == JMSocketConnectionStateConnecting)
		{
			[self disconnect];
		}

}

@end
