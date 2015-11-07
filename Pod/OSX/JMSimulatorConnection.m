//
//  JMSimulatorConnection.m
//  Pods
//
//  Created by Jens Meder on 07/11/15.
//
//

#import "JMSimulatorConnection.h"
#import <netinet/in.h>
#import <sys/socket.h>
#import <sys/ioctl.h>
#import <sys/un.h>
#import <err.h>

static NSUInteger JMSimulatorConnectionBufferSize = 2048;

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

-(void)connect
{
	self.state = JMDeviceConnectionStateConnecting;

	CFReadStreamRef readStream;
	CFWriteStreamRef writeStream;
	
	CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (__bridge CFStringRef) self.host, self.port, &readStream, &writeStream);
	
	_inputStream = (__bridge NSInputStream *)(readStream);
	_outputStream = (__bridge NSOutputStream *)(writeStream);
	
	CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
	CFWriteStreamSetProperty(writeStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
	
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
					   if (eventCode == NSStreamEventHasSpaceAvailable && _inputStream.streamStatus == NSStreamStatusOpen && _outputStream.streamStatus == NSStreamStatusOpen)
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
				   });
}


@end
