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

#import "JMUSBDeviceManager.h"

#import "JMServiceSocket.h"
#import "JMSocketConnection.h"
#import "JMUSBMuxDecoder.h"
#import "JMUSBMuxEncoder.h"

static NSString* const JMServicePath = @"/var/run/usbmuxd";

@interface JMUSBDeviceManager () <JMSocketConnectionDelegate, JMUSBMuxDecoderDelegate>

@end

@implementation JMUSBDeviceManager
{
	@private
	
	JMSocketConnection* _connection;
	JMUSBMuxDecoder* _decoder;

	NSMutableDictionary<NSNumber*, JMUSBDevice*>* _devices;
}

-(instancetype)init
{
	self = [super init];
	
	if (self)
	{
		_decoder = [[JMUSBMuxDecoder alloc]init];
		_decoder.delegate = self;

		_devices = [NSMutableDictionary dictionary];
	}
	
	return self;
}

- (void)start
{
	if (_connection)
	{
		return;
	}
	JMServiceSocket* socket = [[JMServiceSocket alloc]initWithPath:JMServicePath];
	_connection = [[JMSocketConnection alloc]initWithSocket:socket];
	_connection.delegate = self;

	[_connection connect];
}

-(void)stop
{
	[_connection disconnect];
	_connection = nil;
}

#pragma mark - Properties

-(NSArray<JMUSBDevice*> *)attachedDevices
{
	return _devices.allValues;
}

#pragma mark - Delegate

-(void)connection:(JMSocketConnection *)connection didReceiveData:(NSData *)data
{
	[_decoder processData:data];
}

-(void)connection:(JMSocketConnection *)connection didFailToConnect:(NSError *)error
{
	
}

-(void)connection:(JMSocketConnection *)connection didChangeState:(JMSocketConnectionState)state
{
	if (state == JMSocketConnectionStateConnected)
	{
		[_connection writeData:[JMUSBMuxEncoder encodeListeningPacket]];
	}
}

#pragma mark - Decoder Delegate

-(void)decoder:(JMUSBMuxDecoder *)decoder didDecodeAttachPacket:(JMUSBDevice *)device
{
	_devices[device.deviceID] = device;
	[_delegate deviceManager:self deviceDidAttach:device];
}

-(void)decoder:(JMUSBMuxDecoder *)decoder didDecodeDetachPacket:(NSNumber *)deviceID
{
	JMUSBDevice* device = _devices[deviceID];

	if (!device)
	{
		return;
	}

	[_devices removeObjectForKey:deviceID];
	[_delegate deviceManager:self deviceDidDetach:device];
}

@end


