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
#import "JMHostSocket.h"
#import "JMSocketConnection.h"

static NSString* const JMSimulatorConnectionHost	= @"localhost";

@interface JMSimulatorConnection () <JMSocketConnectionDelegate>

@end

@implementation JMSimulatorConnection
{
	@private
	
	JMSocketConnection* _connection;
}

@synthesize state = _state;

-(instancetype)initWithHost:(NSString *)host andPort:(uint32_t)port
{
	if (!host || host.length == 0)
	{
		return nil;
	}
	
	self = [super initWithPort:port];

	if (self)
	{
		JMHostSocket* socket = [[JMHostSocket alloc]initWithHost:host andPort:port];
		_connection = [[JMSocketConnection alloc]initWithSocket:socket];
		_connection.delegate = self;
	}

	return self;
}

-(instancetype)initWithPort:(uint32_t)port
{
	return [self initWithHost:JMSimulatorConnectionHost andPort:port];
}

-(BOOL)connect
{
	return [_connection connect];
}

-(BOOL)writeData:(NSData *)data
{
	return [_connection writeData:data];
}

-(BOOL)disconnect
{
	return [_connection disconnect];
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

#pragma mark - Socket Connection Delegate

-(void)connection:(JMSocketConnection *)connection didChangeState:(JMSocketConnectionState)state
{
	self.state = (JMDeviceConnectionState)state;
}

-(void)connection:(JMSocketConnection *)connection didFailToConnect:(NSError *)error
{
	[self disconnect];
}

-(void)connection:(JMSocketConnection *)connection didReceiveData:(NSData *)data
{
	if ([self.delegate respondsToSelector:@selector(connection:didReceiveData:)])
	{
		[self.delegate connection:self didReceiveData:data];
	}
}


@end
