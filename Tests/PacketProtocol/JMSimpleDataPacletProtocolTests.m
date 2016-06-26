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

@import Kiwi;
#import "JMSimpleDataPacketProtocol.h"

SPEC_BEGIN(JMSimpleDataPacketProtocolTests)

describe(@"JMSimpleDataPacketProtocol", ^{
	
	context(@"when initializing", ^{
		
		it(@"should be possible to create an instance", ^{
			
			JMSimpleDataPacketProtocol* packetProtocol = [[JMSimpleDataPacketProtocol alloc]init];
			[packetProtocol shouldNotBeNil];
		});
		
	});
	
	context(@"when encoding data", ^{
		
		__block JMSimpleDataPacketProtocol* packetProtocol = nil;
		
		beforeEach(^{
			
			packetProtocol = [[JMSimpleDataPacketProtocol alloc]init];
		});
		
		it(@"should be impossible to encode nil", ^{
			
			NSData* encodedData = [packetProtocol encodePacket:nil];
			[encodedData shouldBeNil];
		});
		
		it(@"should be impossible to encode an empty data packet", ^{
			
			NSData* encodedData = [packetProtocol encodePacket:[NSData data]];
			[encodedData shouldBeNil];
		});
		
		it(@"should be impossible to encode a data packet larger than 2^32 bytes", ^{
			
			KWMock* dataMock = [KWMock nullMockForClass:[NSData class]];
			[dataMock stub:@selector(length) andReturn:@((long)UINT32_MAX+1)];
			
			NSData* encodedData = [packetProtocol encodePacket:(NSData*)dataMock];
			[encodedData shouldBeNil];
		});
		
		it(@"should be possible to encode a data packet", ^{
			
			NSData* encodedData = [packetProtocol encodePacket:[@"DarkLightning" dataUsingEncoding:NSUTF8StringEncoding]];
			[encodedData shouldNotBeNil];
		});
	});
	
	context(@"when processing data", ^{
		
		__block JMSimpleDataPacketProtocol* packetProtocol = nil;
		
		beforeEach(^{
			
			packetProtocol = [[JMSimpleDataPacketProtocol alloc]init];
		});
		
		it(@"should be impossible to process nil", ^{
			
			NSArray<NSData*>* decodedData = [packetProtocol processData:nil];
			[decodedData shouldBeNil];
		});
		
		it(@"should be impossible to process an empty data packet", ^{
			
			NSArray<NSData*>* decodedData = [packetProtocol processData:[NSData data]];
			[decodedData shouldBeNil];
		});
	});
	
});

SPEC_END