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

#import "Kiwi.h"
#import "JMUSBMuxDecoder.h"
#import "JMUSBMuxPacketFactory.h"

SPEC_BEGIN(SpecName)

describe(@"JMUSBMuxDecoder",
^{
	
	context(@"when decoding",
	^{
		__block NSObject<JMUSBMuxDecoderDelegate>* delegate;
		
		let(decoder,
		^{
			return [[JMUSBMuxDecoder alloc]init];
		});
		
		beforeEach(
		^{
			delegate = [KWMock mockForProtocol:@protocol(JMUSBMuxDecoderDelegate)];
			[[delegate should] conformToProtocol:@protocol(JMUSBMuxDecoderDelegate)];
			[delegate stub:@selector(decoder:didDecodeAttachPacket:)];
			[delegate stub:@selector(decoder:didDecodeDetachPacket:)];
			[delegate stub:@selector(decoder:didDecodeResultPacket:)];
			decoder.delegate = delegate;
		});
		
		it(@"should not process a nil data parameter",
		^{
			BOOL processed = [decoder processData:nil];
			[[theValue(processed) should] equal:theValue(NO)];
		});
		
		it(@"should not process an empty data parameter",
		^{
			   BOOL processed = [decoder processData:[NSData data]];
			   [[theValue(processed) should] equal:theValue(NO)];
		});
		
		it(@"should process a valid 'Device Attached' usbmuxd packet",
		^{
			NSData* packet = [JMUSBMuxPacketFactory validAttachPacket];
			   
			[[delegate should]receive:@selector(decoder:didDecodeAttachPacket:)];
			   
			[decoder processData:packet];
		});
		
		it(@"should not process a invalid 'Device Attached' usbmuxd packet",
		   ^{
			   NSData* packet = [JMUSBMuxPacketFactory invalidAttachPacket];
			   
			   [[delegate shouldNot]receive:@selector(decoder:didDecodeAttachPacket:)];
			   
			   [decoder processData:packet];
		   });
		
		it(@"should process a valid 'Device Detached' usbmuxd packet",
		   ^{
			   NSData* packet = [JMUSBMuxPacketFactory validDetachPacket];
			   
			   [[delegate should]receive:@selector(decoder:didDecodeDetachPacket:)];
			   
			   [decoder processData:packet];
		   });
		
		it(@"should not process a invalid 'Device Detached' usbmuxd packet",
		   ^{
			   NSData* packet = [JMUSBMuxPacketFactory invalidDetachPacket];
			   
			   [[delegate shouldNot]receive:@selector(decoder:didDecodeDetachPacket:)];
			   
			   [decoder processData:packet];
		   });
		
		it(@"should process a valid 'Result' usbmuxd packet",
		   ^{
			   NSData* packet = [JMUSBMuxPacketFactory validResultPacket];
			   
			   [[delegate should]receive:@selector(decoder:didDecodeResultPacket:)];
			   
			   [decoder processData:packet];
		   });
		
		it(@"should not process an invalid 'Result' usbmuxd packet",
		   ^{
			   NSData* packet = [JMUSBMuxPacketFactory invalidResultPacket];
			   
			   [[delegate shouldNot]receive:@selector(decoder:didDecodeResultPacket:)];
			   
			   [decoder processData:packet];
		   });
	});
});

SPEC_END
