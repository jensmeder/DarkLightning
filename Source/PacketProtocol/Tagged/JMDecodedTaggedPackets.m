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

#import "JMDecodedTaggedPackets.h"
#import "NSData+Immutable.h"

@implementation JMDecodedTaggedPackets

-(instancetype)init {
	
	return [self initWithRawData:[NSData data] andDecodedMessages:@[]];
}

-(instancetype)initWithRawData:(NSData *)data andDecodedMessages:(NSArray<JMTaggedPacket *> *)decodedPackets {
	
	self = [super init];
	
	if (self) {
		
		_rawData = data;
		_decodedPackets = decodedPackets;
	}
	
	return self;
}

-(instancetype)decodedPacketsByProcessingData:(NSData *)data
{
	NSData* buffer = [_rawData dataByAppendingData:data];
	
	uint32_t length = 0;
	uint16_t tag = 0;
	NSUInteger headerLength = sizeof(length) + sizeof(tag);
	
	NSMutableArray<JMTaggedPacket*>* packets = [NSMutableArray array];
	
	while (buffer.length >= headerLength)
	{
		[buffer getBytes:&length length:sizeof(length)];
		[buffer getBytes:&tag range:NSMakeRange(sizeof(length), sizeof(tag))];
		
		length = CFSwapInt32BigToHost(length);
		tag = CFSwapInt16BigToHost(tag);
		
		if (headerLength + length > buffer.length)
		{
			break;
		}
		
		NSData* packetData = [buffer subdataWithRange:NSMakeRange(headerLength, length)];
		JMTaggedPacket* packet = [[JMTaggedPacket alloc]initWithData:packetData andTag:tag length:(uint32_t)packetData.length];
		[packets addObject:packet];
		
		buffer = [buffer subdataWithRange:NSMakeRange(headerLength + length, buffer.length - headerLength - length)];
	}
	
	return [[JMDecodedTaggedPackets alloc]initWithRawData:buffer andDecodedMessages:packets.copy];
}

@end
