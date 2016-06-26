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

#import "JMUSBMuxEncoder.h"
#import "usbmux_packet.h"

static NSString* const JMUSBMuxEncoderDictionaryKeyMessageType 	= @"MessageType";
static NSString* const JMUSBMuxEncoderDictionaryKeyDeviceID 	= @"DeviceID";
static NSString* const JMUSBMuxEncoderDictionaryKeyPortNumber 	= @"PortNumber";

static NSString* const JMUSBMuxEncoderMessageTypeListen 		= @"Listen";
static NSString* const JMUSBMuxEncoderMessageTypeConnect 		= @"Connect";

@implementation JMUSBMuxEncoder

-(instancetype)init
{
	return nil;
}

+(NSData*) packetForPList:(NSDictionary*)plist
{
	NSError *error = nil;

	NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:plist format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];

	if (!error && plistData)
	{
		usbmux_packet_t* packet = CFAllocatorAllocate(kCFAllocatorDefault, sizeof(usbmux_packet_t) + plistData.length, 0);
		memset(packet, 0, sizeof(usbmux_packet_t));
		packet->protocol = USBMuxPacketProtocolPlist;
		packet->tag = 1;
		packet->size = sizeof(usbmux_packet_t) + (uint32_t)plistData.length;
		packet->packetType = USBMuxPacketTypePlistPayload;
		[plistData getBytes:packet->data length:plistData.length];

		return [NSData dataWithBytesNoCopy:packet length:packet->size freeWhenDone:YES];
	}

	return nil;
}

+(NSData *)encodeListeningPacket
{
	static NSData* packet = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken,
	^{
		NSDictionary *plist = @{JMUSBMuxEncoderDictionaryKeyMessageType:JMUSBMuxEncoderMessageTypeListen};
		
		packet = [self packetForPList:plist];
	});
	
	return packet;
}

+(NSData *)encodeConnectPacketForDeviceId:(NSNumber *)deviceId andPort:(uint32_t)aPort
{
	if (!deviceId)
	{
		return nil;
	}
	
	uint32_t port = aPort;
	port = ((port<<8) & 0xFF00) | (port>>8);

	NSDictionary *plist = @{JMUSBMuxEncoderDictionaryKeyMessageType:JMUSBMuxEncoderMessageTypeConnect,
							JMUSBMuxEncoderDictionaryKeyDeviceID: deviceId,
							JMUSBMuxEncoderDictionaryKeyPortNumber:@(port)};

	return [self packetForPList:plist];
}

@end
