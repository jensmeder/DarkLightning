//
//  JMUSBMuxPacketFactory.m
//  DarkLightning
//
//  Created by Jens Meder on 15/11/15.
//  Copyright © 2015 Jens Meder. All rights reserved.
//

#import "JMUSBMuxPacketFactory.h"
#import "usbmux_packet.h"

static NSString* const JMUSBMuxDecoderDictionaryKeyMessageType 	= @"MessageType";
static NSString* const JMUSBMuxDecoderDictionaryKeyDeviceID 	= @"DeviceID";
static NSString* const JMUSBMuxDecoderDictionaryKeyNumber 		= @"Number";

static NSString* const JMUSBMuxEncoderMessageTypeAttached 		= @"Attached";
static NSString* const JMUSBMuxEncoderMessageTypeDetached 		= @"Detached";
static NSString* const JMUSBMuxEncoderMessageTypeResult 		= @"Result";

static NSString* const JMUSBDeviceDictionaryKeyProperties 		= @"Properties";

static NSString* const JMUSBDeviceDictionaryKeyDeviceID 		= @"DeviceID";
static NSString* const JMUSBDeviceDictionaryKeySerialNumber 	= @"SerialNumber";
static NSString* const JMUSBDeviceDictionaryKeyConnectionSpeed 	= @"ConnectionSpeed";
static NSString* const JMUSBDeviceDictionaryKeyProductID 		= @"ProductID";
static NSString* const JMUSBDeviceDictionaryKeyLocationID 		= @"LocationID";

@implementation JMUSBMuxPacketFactory

+(NSData*) packetForDictionary:(NSDictionary*)dictionary
{
	NSError* error = nil;
	NSData* data = [NSPropertyListSerialization dataWithPropertyList:dictionary format:NSPropertyListXMLFormat_v1_0 options:NSPropertyListImmutable error:&error];
	
	usbmux_packet_t packet;
	memset(&packet, 0, sizeof(packet));
	
	packet.size = (uint32_t)(sizeof(packet) + data.length);
	packet.tag = 0;
	packet.packetType = USBMuxPacketTypeDeviceAdd;
	packet.protocol = USBMuxPacketProtocolPlist;
	
	NSMutableData* packetData = [NSMutableData dataWithBytes:&packet length:sizeof(packet)];
	[packetData appendData:data];
	
	return packetData;
}

+(NSData *)validAttachPacket
{
	NSDictionary* properties = @{JMUSBDeviceDictionaryKeyDeviceID:@1};
	NSDictionary* dictionary = @{JMUSBMuxDecoderDictionaryKeyMessageType:JMUSBMuxEncoderMessageTypeAttached, JMUSBDeviceDictionaryKeyProperties:properties};
	
	return [JMUSBMuxPacketFactory packetForDictionary:dictionary];
}

+(NSData *)invalidAttachPacket
{
	NSDictionary* dictionary = @{JMUSBMuxDecoderDictionaryKeyMessageType:JMUSBMuxEncoderMessageTypeAttached};
	
	return [JMUSBMuxPacketFactory packetForDictionary:dictionary];
}

+(NSData *)validDetachPacket
{
	NSDictionary* dictionary = @{JMUSBMuxDecoderDictionaryKeyMessageType:JMUSBMuxEncoderMessageTypeDetached, JMUSBMuxDecoderDictionaryKeyDeviceID:@1};
	
	return [JMUSBMuxPacketFactory packetForDictionary:dictionary];
}

+(NSData *)invalidDetachPacket
{
	NSDictionary* dictionary = @{JMUSBMuxDecoderDictionaryKeyMessageType:JMUSBMuxEncoderMessageTypeDetached};
	
	return [JMUSBMuxPacketFactory packetForDictionary:dictionary];
}

+(NSData *)validResultPacket
{
	NSDictionary* dictionary = @{JMUSBMuxDecoderDictionaryKeyMessageType:JMUSBMuxEncoderMessageTypeResult, JMUSBMuxDecoderDictionaryKeyNumber:@1};
	
	return [JMUSBMuxPacketFactory packetForDictionary:dictionary];
}

+(NSData *)invalidResultPacket
{
	NSDictionary* dictionary = @{JMUSBMuxDecoderDictionaryKeyMessageType:JMUSBMuxEncoderMessageTypeResult};
	
	return [JMUSBMuxPacketFactory packetForDictionary:dictionary];
}

@end
