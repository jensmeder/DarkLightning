/**
 *	JMUSBDeviceConnection.m
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

#import "JMUSBDeviceConnection.h"
#import "JMUSBChannel.h"
#import "JMUSBMuxEncoder.h"
#import "JMUSBMuxDecoder.h"

NSString* const JMUSBDeviceConnectionErrorDomain 			= @"JMUSBDeviceConnectionError";

NSInteger JMUSBDeviceConnectionErrorCodeDeviceNotAvailable 	= 100;
NSInteger JMUSBDeviceConnectionErrorCodeDataStreamError 	= 200;

@interface JMUSBDeviceConnection()<JMUSBChannelDelegate, JMUSBMuxDecoderDelegate>

@end

@implementation JMUSBDeviceConnection
{
	@private
	
	JMUSBChannel* 		_channel;
	JMUSBMuxDecoder* 	_decoder;
	JMUSBMuxEncoder* 	_encoder;
	
	BOOL 				_tcpMode;
}

-(instancetype)initWithDevice:(JMUSBDevice *)device andPort:(uint32_t)port
{
	self = [super init];
	
	if (self)
	{
		_device = device;
		_port = port;
		
		_decoder = [[JMUSBMuxDecoder alloc]init];
		_decoder.delegate = self;

		_encoder = [[JMUSBMuxEncoder alloc]init];
		
		_tcpMode = NO;
		_state = JMUSBDeviceConnectionStateDisconnected;
	}
	
	return self;
}

-(void)connect
{
	if (_channel)
	{
		return;
	}
	_channel = [[JMUSBChannel alloc]init];
	_channel.delegate = self;
	[_channel open];
	self.state = JMUSBDeviceConnectionStateConnecting;
}

-(void)disconnect
{
	if (!_channel)
	{
		return;
	}
	
	[_channel close];
	_channel = nil;
	_tcpMode = NO;
	self.state = JMUSBDeviceConnectionStateDisconnected;
}

-(BOOL)writeData:(NSData *)data
{
	if (_tcpMode)
	{
		[_channel writeData:data];
		return YES;
	}

	return NO;
}

#pragma mark - Properties

-(void)setState:(JMUSBDeviceConnectionState)state
{
	_state = state;
	
	if ([_delegate respondsToSelector:@selector(connection:didChangeState:)])
	{
		[_delegate connection:self didChangeState:_state];
	}
}

#pragma mark - Decoder Delegate

-(void)decoder:(JMUSBMuxDecoder *)decoder didDecodeResultPacket:(JMUSBMuxResultCode)resultCode
{
	if (resultCode == JMUSBMuxResultCodeOK)
	{
		self.state = JMUSBDeviceConnectionStateConnected;
		_tcpMode = YES;
	}
	else
	{
		[self disconnect];
		
		if ([_delegate respondsToSelector:@selector(connection:didFailToConnect:)])
		{
			NSError* error = [NSError errorWithDomain:JMUSBDeviceConnectionErrorDomain code:JMUSBDeviceConnectionErrorCodeDeviceNotAvailable userInfo:nil];
			[_delegate connection:self didFailToConnect:error];
		}
	}
}

#pragma mark - USB Delegate

-(void)channel:(JMUSBChannel *)channel didChangeState:(JMUSBChannelState)state
{
	if (state == JMUSBChannelStateConnected)
	{
		[_channel writeData:[_encoder encodeConnectPacketForDeviceId:_device.deviceID andPort:_port]];
	}
}

-(void)channel:(JMUSBChannel *)channel didFailToOpen:(NSError *)internalError
{
	[self disconnect];
	
	if ([_delegate respondsToSelector:@selector(connection:didFailToConnect:)])
	{
		NSError* error = [NSError errorWithDomain:JMUSBDeviceConnectionErrorDomain code:JMUSBDeviceConnectionErrorCodeDataStreamError userInfo:nil];
		[_delegate connection:self didFailToConnect:error];
	}
}

-(void)channel:(JMUSBChannel *)channel didReceiveData:(NSData *)data
{
	if (_tcpMode)
	{
		if ([_delegate respondsToSelector:@selector(connection:didReceiveData:)])
		{
			[_delegate connection:self didReceiveData:data];
		}
		
		return;
	}
	
	[_decoder processData:data];
}

@end
