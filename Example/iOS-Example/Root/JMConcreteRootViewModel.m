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
#import <UIKit/UIkit.h>
#import <DarkLightning/JMSimpleDataPacketProtocol.h>

@interface JMConcreteRootViewModel () <JMMobileDevicePortDelegate>

@end

@implementation JMConcreteRootViewModel
{
	@private
	
	id<JMDataPacketProtocol> _packetProtocol;
}

@synthesize connectionState = _connectionState;
@synthesize delegate = _delegate;
@synthesize message = _message;

-(instancetype)initWithDevicePort:(JMMobileDevicePort *)devicePort
{
	if (!devicePort)
	{
		return nil;
	}
	
	self = [super init];
	
	if (self)
	{
		_devicePort = devicePort;
		_devicePort.delegate = self;
		_connectionState = (JMRootViewModelConnectionState) _devicePort.state;
		
		_packetProtocol = [[JMSimpleDataPacketProtocol alloc]init];
	}
	
	return self;
}

-(BOOL)sendMessage
{
	if (_message && _devicePort.state != JMMobileDevicePortStateConnected)
	{
		return NO;
	}
	
	NSData* messageData = [_message dataUsingEncoding:NSUTF8StringEncoding];
	NSData* packet = [_packetProtocol encodePacket:messageData];
	
	_message = nil;
	
	return [_devicePort writeData:packet];
}

#pragma mark - Delegate

-(void)mobileDevicePort:(JMMobileDevicePort *)port didChangeState:(JMMobileDevicePortState)state
{
	if(state != JMMobileDevicePortStateConnected)
	{
		[_packetProtocol reset];
	}
	else if(state == JMMobileDevicePortStateConnected)
	{
		NSString* helloMessage = [NSString stringWithFormat:@"Hello, I am %@",[UIDevice currentDevice].name];
		NSData* messageData = [helloMessage dataUsingEncoding:NSUTF8StringEncoding];
		[port writeData:[_packetProtocol encodePacket:messageData]];
	}
	
	_connectionState = (JMRootViewModelConnectionState) _devicePort.state;
	
	[_delegate rootViewModel:self didChangeConnectionState:(JMRootViewModelConnectionState)state];
}

-(void)mobileDevicePort:(JMMobileDevicePort *)port didReceiveData:(NSData *)data
{
	NSArray<NSData*>* packets = [_packetProtocol processData:data];
	
	for (NSData* packet in packets)
	{
		NSString* message = [[NSString alloc]initWithData:packet encoding:NSUTF8StringEncoding];
		
		[_delegate rootViewModel:self didReceiveMessage:message];
	}
}

@end
