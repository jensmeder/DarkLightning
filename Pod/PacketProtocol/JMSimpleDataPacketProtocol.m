//
//  JMSimpleDataPacketProtocol.m
//  Pods
//
//  Created by Jens Meder on 07/11/15.
//
//

#import "JMSimpleDataPacketProtocol.h"

@implementation JMSimpleDataPacketProtocol
{
	@private
	
	NSMutableData* _buffer;
}

-(instancetype)init
{
	self = [super init];
	
	if (self)
	{
		_buffer = [NSMutableData data];
	}
	
	return self;
}

-(NSData *)encodePacket:(NSData *)packet
{
	if (!packet || packet.length > UINT32_MAX)
	{
		return nil;
	}
	
	uint32_t packetLength = (uint32_t)packet.length;
	
	NSMutableData* data = [NSMutableData dataWithBytes:&packetLength length:sizeof(uint32_t)];
	[data appendData:packet];
	
	return data;
}

-(NSArray<NSData *> *)processData:(NSData *)data
{
	[_buffer appendData:data];
	
	uint32_t length = 0;
	
	if (_buffer.length < sizeof(length))
	{
		return nil;
	}
	
	memcpy(&length, _buffer.bytes, sizeof(length));
	
	NSMutableArray* packets = [NSMutableArray array];
	
	while (sizeof(length) + length < _buffer.length)
	{
		NSData* packet = [_buffer subdataWithRange:NSMakeRange(sizeof(length), length)];
		[packets addObject:packet];
		
		[_buffer replaceBytesInRange:NSMakeRange(0, sizeof(length) + length) withBytes:NULL length:0];
	}
	
	return packets;
}

-(void)reset
{
	_buffer = [NSMutableData data];
}

@end
