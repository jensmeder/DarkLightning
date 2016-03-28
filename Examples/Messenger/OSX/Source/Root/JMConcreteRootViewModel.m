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

#import "JMConcreteRootViewModel.h"
@import DarkLightning;

@interface JMConcreteRootViewModel () <JMUSBDeviceManagerDelegate, JMDeviceConnectionDelegate>

@end

@implementation JMConcreteRootViewModel
{
	@private
	
	JMUSBDeviceConnection* _deviceConnection;
	JMSimulatorConnection* _simulatorConnection;
	
	JMTaggedPacketProtocol* _packetProtocol;
}

@synthesize delegate = _delegate;

-(instancetype)initWithDeviceManager:(JMUSBDeviceManager *)deviceManager
{
	self = [super init];
	
	if (self)
	{
		_deviceManager = deviceManager;
		_deviceManager.delegate = self;
		
		_simulatorConnection = [[JMSimulatorConnection alloc]initWithPort:2347];
		_simulatorConnection.delegate = self;
		[_simulatorConnection connect];
		
		_packetProtocol = [[JMTaggedPacketProtocol alloc]init];
	}
	
	return self;
}

-(BOOL)sendMessage:(NSString *)message
{
	NSData* data = [message dataUsingEncoding:NSUTF8StringEncoding];
	JMTaggedPacket* packet = [[JMTaggedPacket alloc]initWithData:data andTag:(uint16_t)12345];
	data = [_packetProtocol encodePacket:packet];
	
	if (_deviceConnection.state == JMDeviceConnectionStateConnected)
	{
		[_deviceConnection writeData:data];
		
		return YES;
	}
	else if(_simulatorConnection.state == JMDeviceConnectionStateConnected)
	{
		[_simulatorConnection writeData:data];
		
		return YES;
	}
	
	return NO;
}

#pragma mark - Device Manager Delegate

-(void)deviceManager:(JMUSBDeviceManager *)manager deviceDidChangeState:(JMUSBDeviceManagerState)state
{

}

-(void)deviceManager:(JMUSBDeviceManager *)manager deviceDidAttach:(JMUSBDevice *)device
{
	if (!_deviceConnection)
	{
		
		_deviceConnection = [[JMUSBDeviceConnection alloc]initWithDevice:device andPort:2347];
		_deviceConnection.delegate = self;
		[_deviceConnection connect];
	}
}

-(void)deviceManager:(JMUSBDeviceManager *)manager deviceDidDetach:(JMUSBDevice *)device
{
	if ([_deviceConnection.device isEqual:device])
	{
		[_deviceConnection disconnect];
		_deviceConnection.delegate = nil;
		[_packetProtocol reset];
		_deviceConnection = nil;
	}
}

#pragma mark - Device Connection Delegate

-(void)connection:(JMDeviceConnection *)connection didChangeState:(JMDeviceConnectionState)state
{
	if(state == JMDeviceConnectionStateConnected)
	{
		if (connection == _deviceConnection)
		{
			[_simulatorConnection disconnect];
			[_delegate rootViewModel:self didConnectToDeviceWithName:_deviceConnection.device.serialNumber];
		}
		else
		{
			[_delegate rootViewModel:self didConnectToDeviceWithName:@"Simulator"];
		}
		
		NSProcessInfo *pInfo = [NSProcessInfo processInfo];
		NSString *version = [pInfo operatingSystemVersionString];
		[self sendMessage:[NSString stringWithFormat:@"Hello, I am %@ running OSX %@",[[NSHost currentHost] localizedName], version]];
	}
	else if(state == JMDeviceConnectionStateDisconnected)
	{
		if (connection == _deviceConnection)
		{
			[_simulatorConnection connect];
		}
		[_delegate rootViewModelDidDisconnectFromDevice:self];
	}
	else
	{
		[_packetProtocol reset];
	}
}

-(void)connection:(JMDeviceConnection *)connection didFailToConnect:(NSError *)error
{
	
}

-(void)connection:(JMDeviceConnection *)connection didReceiveData:(NSData *)data
{
	NSArray<JMTaggedPacket*>* packets = [_packetProtocol processData:data];
	
	for (JMTaggedPacket* packet in packets)
	{
		NSString* message = [[NSString alloc]initWithData:packet.data encoding:NSUTF8StringEncoding];
		[_delegate rootViewModel:self didReceiveMessage:message];
	}
	
}

@end
