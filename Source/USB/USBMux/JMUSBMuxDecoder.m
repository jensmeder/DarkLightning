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

#import "JMUSBMuxDecoder.h"
#import "JMUSBMuxPacket.h"

static NSString* const JMUSBMuxDecoderDictionaryKeyMessageType 	= @"MessageType";
static NSString* const JMUSBMuxDecoderDictionaryKeyDeviceID 	= @"DeviceID";
static NSString* const JMUSBMuxDecoderDictionaryKeyNumber 		= @"Number";

static NSString* const JMUSBMuxEncoderMessageTypeAttached 		= @"Attached";
static NSString* const JMUSBMuxEncoderMessageTypeDetached 		= @"Detached";
static NSString* const JMUSBMuxEncoderMessageTypeResult 		= @"Result";

@implementation JMUSBMuxDecoder

-(void) decodePacket:(NSData*)data
{
	NSError* error = nil;
	NSDictionary* plist = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:NULL error:&error];

	if (!error && plist)
	{
		NSString *messageType = plist[JMUSBMuxDecoderDictionaryKeyMessageType];
		
		if (!messageType)
		{
			return;
		}
		
		if ([JMUSBMuxEncoderMessageTypeAttached isEqualToString:messageType])
		{
			JMUSBDevice* device = [[JMUSBDevice alloc]initWithPList:plist];
			
			if (!device)
			{
				return;
			}

			if ([_delegate respondsToSelector:@selector(decoder:didDecodeAttachPacket:)])
			{
				[_delegate decoder:self didDecodeAttachPacket:device];
			}
		}
		else if ([JMUSBMuxEncoderMessageTypeDetached isEqualToString:messageType])
		{
			NSNumber* deviceID = plist[JMUSBMuxDecoderDictionaryKeyDeviceID];
			
			if (!deviceID)
			{
				return;
			}

			if ([_delegate respondsToSelector:@selector(decoder:didDecodeDetachPacket:)])
			{
				[_delegate decoder:self didDecodeDetachPacket:deviceID];
			}
		}
		else if([JMUSBMuxEncoderMessageTypeResult isEqualToString:messageType])
		{
			NSNumber* resultCode = plist[JMUSBMuxDecoderDictionaryKeyNumber];
			
			if (!resultCode)
			{
				return;
			}
			
			if ([_delegate respondsToSelector:@selector(decoder:didDecodeResultPacket:)])
			{
				[_delegate decoder:self didDecodeResultPacket:(JMUSBMuxResultCode)resultCode.unsignedIntegerValue];
			}
		}
	}
}

-(void)processData:(NSData *)aData
{
	NSData* data = aData;

	while (data.length) {
		
		NSData* headerData = [data subdataWithRange:NSMakeRange(0, 16)];
		data = [data subdataWithRange:NSMakeRange(16, data.length - 16)];
		JMUSBMuxPacketHeader* header = [[JMUSBMuxPacketHeader alloc]initWithData:headerData];

		if (header.payloadSize > data.length) {
			
			break;
		}

		NSData* payload = [data subdataWithRange:NSMakeRange(0, header.payloadSize)];
		data = [data subdataWithRange:NSMakeRange(payload.length, data.length - payload.length)];

		[self decodePacket:payload];
	}
}

@end
