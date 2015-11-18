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

#import "JMUSBDeviceConnection.h"
#import "JMServiceSocket.h"
#import "JMSocketConnection.h"
#import "JMUSBMuxEncoder.h"
#import "JMUSBMuxDecoder.h"

static NSString* const JMServicePath = @"/var/run/usbmuxd";

@interface JMUSBDeviceConnection()<JMSocketConnectionDelegate, JMUSBMuxDecoderDelegate>

@end

@implementation JMUSBDeviceConnection
{
	@private
	
	JMSocketConnection* _connection;
	JMUSBMuxDecoder* 	_decoder;
	
	BOOL 				_tcpMode;
}

@synthesize state = _state;

-(instancetype)initWithDevice:(JMUSBDevice *)device andPort:(uint32_t)port
{
	self = [super initWithPort:port];
	
	if (self)
	{
		_device = device;
		
		_decoder = [[JMUSBMuxDecoder alloc]init];
		_decoder.delegate = self;
		
		_tcpMode = NO;
		_state = JMDeviceConnectionStateDisconnected;
		
		JMServiceSocket* socket = [[JMServiceSocket alloc]initWithPath:JMServicePath];
		_connection = [[JMSocketConnection alloc]initWithSocket:socket];
		_connection.delegate = self;
	}
	
	return self;
}

-(BOOL)connect
{
	if (self.state != JMDeviceConnectionStateDisconnected)
	{
		return NO;
	}

	self.state = JMDeviceConnectionStateConnecting;
	
	return [_connection connect];
}

-(BOOL)disconnect
{
	if (self.state == JMDeviceConnectionStateDisconnected)
	{
		return NO;
	}
	
	[_connection disconnect];

	_tcpMode = NO;
	self.state = JMDeviceConnectionStateDisconnected;
	
	return YES;
}

-(BOOL)writeData:(NSData *)data
{
	if (self.state != JMDeviceConnectionStateConnected)
	{
		return NO;
	}
	
	if (_tcpMode)
	{
		return [_connection writeData:data];
	}

	return NO;
}

#pragma mark - Properties

-(void)setState:(JMDeviceConnectionState)state
{
	if (_state == state)
	{
		return;
	}

	_state = state;
	
	if ([self.delegate respondsToSelector:@selector(connection:didChangeState:)])
	{
		[self.delegate connection:self didChangeState:_state];
	}
}

#pragma mark - Decoder Delegate

-(void)decoder:(JMUSBMuxDecoder *)decoder didDecodeResultPacket:(JMUSBMuxResultCode)resultCode
{
	if (resultCode == JMUSBMuxResultCodeOK)
	{
		_tcpMode = YES;
		self.state = JMDeviceConnectionStateConnected;
	}
	else
	{
		[self disconnect];
		
		if ([self.delegate respondsToSelector:@selector(connection:didFailToConnect:)])
		{
			NSError* error = [NSError errorWithDomain:JMDeviceConnectionErrorDomain
                                                 code:JMDeviceConnectionErrorCodeDeviceNotAvailable
                                             userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Device not available.", nil)}];
			[self.delegate connection:self didFailToConnect:error];
		}
	}
}

#pragma mark - USB Delegate

-(void)connection:(JMSocketConnection *)connection didChangeState:(JMSocketConnectionState)state
{
	if (state == JMSocketConnectionStateConnected)
	{
		[_connection writeData:[JMUSBMuxEncoder encodeConnectPacketForDeviceId:_device.deviceID andPort:self.port]];
	}
	else if(state == JMSocketConnectionStateDisconnected)
	{
		[self disconnect];
	}
}

-(void)connection:(JMSocketConnection *)connection didFailToConnect:(NSError *)error
{
	[self disconnect];
	
	if ([self.delegate respondsToSelector:@selector(connection:didFailToConnect:)])
	{
		NSError* error = [NSError errorWithDomain:JMDeviceConnectionErrorDomain
                                             code:JMDeviceConnectionErrorCodeDataStreamError
                                         userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Data stream error.", nil)}];
		[self.delegate connection:self didFailToConnect:error];
	}
}

-(void)connection:(JMSocketConnection *)connection didReceiveData:(NSData *)data
{
	if (_tcpMode)
	{
		if ([self.delegate respondsToSelector:@selector(connection:didReceiveData:)])
		{
			[self.delegate connection:self didReceiveData:data];
		}
		
		return;
	}
	
	[_decoder processData:data];
}

@end
