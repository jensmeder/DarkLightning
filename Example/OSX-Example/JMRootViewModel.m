//
//  JMRootViewModel.m
//  DarkLightning
//
//  Created by Jens Meder on 07/11/15.
//  Copyright © 2015 Jens Meder. All rights reserved.
//

#import "JMRootViewModel.h"
#import <DarkLightning/JMUSBDeviceConnection.h>

@interface JMRootViewModel () <JMUSBDeviceManagerDelegate, JMUSBDeviceConnectionDelegate>

@end

@implementation JMRootViewModel
{
	@private
	
	JMUSBDeviceConnection* _deviceConnection;
}

-(instancetype)initWithDeviceManager:(JMUSBDeviceManager *)deviceManager
{
	self = [super init];
	
	if (self)
	{
		_deviceManager = deviceManager;
		_deviceManager.delegate = self;
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
		_deviceConnection = nil;
	}
}

#pragma mark - Device Connection Delegate

-(void)connection:(JMUSBDeviceConnection *)connection didChangeState:(JMUSBDeviceConnectionState)state
{
	
}

-(void)connection:(JMUSBDeviceConnection *)connection didFailToConnect:(NSError *)error
{
	
}

-(void)connection:(JMUSBDeviceConnection *)connection didReceiveData:(NSData *)data
{
	
}

@end
