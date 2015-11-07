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

#import "JMRootViewModel.h"
#import <DarkLightning/JMUSBDeviceConnection.h>
#import <DarkLightning/JMSimpleDataPacketProtocol.h>
#import <DarkLightning/JMSimulatorConnection.h>

@interface JMRootViewModel () <JMUSBDeviceManagerDelegate, JMDeviceConnectionDelegate>

@end

@implementation JMRootViewModel
{
	@private
	
	JMUSBDeviceConnection* _deviceConnection;
	JMSimulatorConnection* _simulatorConnection;
	
	id<JMDataPacketProtocol> _packetProtocol;
}

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

#pragma mark - Device Manager Delegate

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
		_deviceConnection.delegate = nil;
		[_deviceConnection disconnect];
		[_packetProtocol reset];
		_deviceConnection = nil;
	}
}

#pragma mark - Device Connection Delegate

-(void)connection:(JMDeviceConnection *)connection didChangeState:(JMDeviceConnectionState)state
{
	if(state == JMDeviceConnectionStateConnected)
	{
		for (int i = 0; i < 50; i++)
		{
			NSData* data = [@"World" dataUsingEncoding:NSUTF8StringEncoding];
			
			[connection writeData:[_packetProtocol encodePacket:data]];
		}
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
		NSLog(@"%@",[[NSString alloc]initWithData:packet encoding:NSUTF8StringEncoding]);
	}
	
}

@end
