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

#import "JMTaggedPacket.h"

@implementation JMTaggedPacket

-(instancetype)init {
	
	return [self initWithData:[NSData data] andTag:0 length:0];
}

-(instancetype)initWithTag:(uint16_t)tag {
	
	return [self initWithData:[NSData data] andTag:tag length:0];
}

-(instancetype)initWithData:(NSData *)data andTag:(uint16_t)tag length:(uint32_t)length
{
	self = [super init];
	
	if (self)
	{
		_data = data;
		_tag = tag;
		_length = length;
	}
	
	return self;
}

-(BOOL)isEqual:(id)object {
	
	BOOL isEqual = NO;
	
	if ([object isKindOfClass:[JMTaggedPacket class]]) {
		
		JMTaggedPacket* obj = object;
		isEqual = _tag == obj.tag && [_data isEqualToData:obj.data];
	}
	
	return isEqual;
}

-(NSUInteger)hash {
	
	return _data.hash ^ _tag;
}

#pragma mark - Properties

-(NSData *)encodedPacket
{
	uint32_t packetLength = CFSwapInt32HostToBig((uint32_t)_length);
	uint16_t tag = CFSwapInt16HostToBig((uint16_t)_tag);
	
	NSMutableData* data = [NSMutableData dataWithBytes:&packetLength length:sizeof(packetLength)];
	[data appendBytes:&tag length:sizeof(tag)];
	[data appendData:_data];
	
	return data.copy;
}

@end
