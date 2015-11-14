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
#import <DarkLightning/JMUSBDeviceConnection.h>
#import <DarkLightning/JMSimpleDataPacketProtocol.h>
#import <DarkLightning/JMSimulatorConnection.h>

@interface JMConcreteRootViewModel () <JMUSBDeviceManagerDelegate, JMDeviceConnectionDelegate>

@end

@implementation JMConcreteRootViewModel
{
	@private
	
	JMUSBDeviceConnection* _deviceConnection;
	JMSimulatorConnection* _simulatorConnection;
	
	id<JMDataPacketProtocol> _packetProtocol;
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
		
		_packetProtocol = [[JMSimpleDataPacketProtocol alloc]init];
	}
	
	return self;
}

-(BOOL)sendMessage:(NSString *)message
{
	NSData* data = [message dataUsingEncoding:NSUTF8StringEncoding];
	data = [_packetProtocol encodePacket:data];
	
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

-(void)deviceManager:(JMUSBDeviceManager *)manager deviceDidAttach:(JMUSBDevice *)device
{
	if (!_deviceConnection)
	{
		[_simulatorConnection disconnect];
		_deviceConnection = [[JMUSBDeviceConnection alloc]initWithDevice:device andPort:2347];
		_deviceConnection.delegate = self;
		[_deviceConnection connect];
	}
}

-(void)deviceManager:(JMUSBDeviceManager *)manager deviceDidDetach:(JMUSBDevice *)device
{
	if ([_deviceConnection.device isEqual:device])
	{
		[_simulatorConnection connect];
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
			[_delegate rootViewModel:self didConnectToDeviceWithName:_deviceConnection.device.serialNumber];
		}
		else
		{
			[_delegate rootViewModel:self didConnectToDeviceWithName:@"Simulator"];
		}
		
		[self sendMessage:[NSString stringWithFormat:@"Hello, I am %@",[[NSHost currentHost] localizedName]]];
	}
	else if(state == JMDeviceConnectionStateDisconnected)
	{
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
	NSArray<NSData*>* packets = [_packetProtocol processData:data];
	
	for (NSData* packet in packets)
	{
		NSString* message = [[NSString alloc]initWithData:packet encoding:NSUTF8StringEncoding];
		[_delegate rootViewModel:self didReceiveMessage:message];
	}
	
}

@end
