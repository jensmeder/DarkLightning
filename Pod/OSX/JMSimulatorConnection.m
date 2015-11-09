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

#import "JMSimulatorConnection.h"
#import <netinet/in.h>
#import <sys/socket.h>
#import <sys/ioctl.h>
#import <sys/un.h>
#import <err.h>

static NSUInteger JMSimulatorConnectionBufferSize = 2048;
static NSString* const JMSimulatorConnectionHost = @"localhost";

@interface JMSimulatorConnection () <NSStreamDelegate>

@end

@implementation JMSimulatorConnection
{
	@private
	
	NSInputStream* 		_inputStream;
	NSOutputStream* 	_outputStream;
	
	NSRunLoop* _backgroundRunLoop;
}

@synthesize state = _state;

-(instancetype)initWithHost:(NSString *)host andPort:(uint32_t)port
{
	self = [super initWithPort:port];

	if (self)
	{
		_host = host;
	}

	return self;
}

-(instancetype)initWithPort:(uint32_t)port
{
	return [self initWithHost:JMSimulatorConnectionHost andPort:port];
}

-(void)connect
{
	self.state = JMDeviceConnectionStateConnecting;

	CFReadStreamRef readStream;
	CFWriteStreamRef writeStream;
	
	CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (__bridge CFStringRef) self.host, self.port, &readStream, &writeStream);
	
	_inputStream = (__bridge NSInputStream *)(readStream);
	_outputStream = (__bridge NSOutputStream *)(writeStream);
	
	CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanFalse);
	CFWriteStreamSetProperty(writeStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanFalse);
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),
				   ^{
					   _backgroundRunLoop = [NSRunLoop currentRunLoop];
					   [_inputStream scheduleInRunLoop:_backgroundRunLoop forMode:NSDefaultRunLoopMode];
					   [_outputStream scheduleInRunLoop:_backgroundRunLoop forMode:NSDefaultRunLoopMode];
					   
					   _inputStream.delegate = self;
					   _outputStream.delegate = self;
					   
					   [_inputStream open];
					   [_outputStream open];
					   
					   [_backgroundRunLoop run];
				   });
	
}

-(BOOL)writeData:(NSData *)data
{
	if (_state != JMDeviceConnectionStateConnected)
	{
		return NO;
	}
	
	NSInteger bytesWritten = [_outputStream write:data.bytes maxLength:data.length];
	
	if(bytesWritten > 0)
	{
		return YES;
	}
	
	return NO;
}

-(void)disconnect
{
	_inputStream.delegate = self;
	_outputStream.delegate = self;
	
	[_inputStream removeFromRunLoop:_backgroundRunLoop forMode:NSDefaultRunLoopMode];
	[_outputStream removeFromRunLoop:_backgroundRunLoop forMode:NSDefaultRunLoopMode];
	
	[_inputStream close];
	[_outputStream close];
	
	_inputStream = nil;
	_outputStream = nil;
	
	_backgroundRunLoop = nil;
	
	self.state = JMDeviceConnectionStateDisconnected;
}

-(void) setState:(JMDeviceConnectionState)connectionState
{
	if (_state == connectionState)
	{
		return;
	}
	
	_state = connectionState;
	
	if([self.delegate respondsToSelector:@selector(connection:didChangeState:)])
	{
		dispatch_async(dispatch_get_main_queue(),
					   ^{
						   [self.delegate connection:self didChangeState:_state];
					   });
	}
}

#pragma mark - Stream Delegate

-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
	dispatch_async(dispatch_get_main_queue(),
	^{
		if (_state != JMDeviceConnectionStateConnected && eventCode == NSStreamEventHasSpaceAvailable && _inputStream.streamStatus == NSStreamStatusOpen && _outputStream.streamStatus == NSStreamStatusOpen)
		{
			self.state = JMDeviceConnectionStateConnected;
		}
		else if(eventCode == NSStreamEventHasBytesAvailable)
		{
			NSMutableData* data = [NSMutableData data];
			uint8_t buffer[JMSimulatorConnectionBufferSize];
						   
			while (_inputStream.hasBytesAvailable)
			{
				NSInteger length = [_inputStream read:buffer maxLength:JMSimulatorConnectionBufferSize];
				[data appendBytes:buffer length:length];
			}
						   
			if ([self.delegate respondsToSelector:@selector(connection:didReceiveData:)])
			{
				dispatch_async(dispatch_get_main_queue(),
				^{
					[self.delegate connection:self didReceiveData:data];
				});
			}
		}
		else if (eventCode == NSStreamEventEndEncountered)
		{
			self.state = JMDeviceConnectionStateDisconnected;
		}
		else if(eventCode == NSStreamEventErrorOccurred && self.state == JMDeviceConnectionStateConnecting)
		{
			self.state = JMDeviceConnectionStateDisconnected;

			NSError* error = [NSError errorWithDomain:JMDeviceConnectionErrorDomain code:JMDeviceConnectionErrorCodeDataStreamError userInfo:nil];
			[self.delegate connection:self didFailToConnect:error];
		}
	});
}


@end
