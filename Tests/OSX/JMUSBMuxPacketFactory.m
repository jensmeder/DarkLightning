//
//  JMUSBMuxPacketFactory.m
//  DarkLightning
//
//  Created by Jens Meder on 15/11/15.
//  Copyright © 2015 Jens Meder. All rights reserved.
//

#import "JMUSBMuxPacketFactory.h"
#import "usbmux_packet.h"

static NSString* const JMDictionaryKeyMessageType 	= @"MessageType";
static NSString* const JMDictionaryKeyDeviceID 	= @"DeviceID";
static NSString* const JMDictionaryKeyNumber 		= @"Number";

static NSString* const JMMessageTypeAttached 		= @"Attached";
static NSString* const JMMessageTypeDetached 		= @"Detached";
static NSString* const JMMessageTypeResult 		= @"Result";

static NSString* const JMDictionaryKeyProperties 		= @"Properties";

static NSString* const JMDictionaryKeySerialNumber 	= @"SerialNumber";
static NSString* const JMDictionaryKeyConnectionSpeed 	= @"ConnectionSpeed";
static NSString* const JMDictionaryKeyProductID 		= @"ProductID";
static NSString* const JMDictionaryKeyLocationID 		= @"LocationID";

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
	NSDictionary* properties = @{JMDictionaryKeyDeviceID:@1};
	NSDictionary* dictionary = @{JMDictionaryKeyMessageType:JMMessageTypeAttached, JMDictionaryKeyProperties:properties};
	
	return [JMUSBMuxPacketFactory packetForDictionary:dictionary];
}

+(NSData *)invalidAttachPacket
{
	NSDictionary* dictionary = @{JMDictionaryKeyMessageType:JMMessageTypeAttached};
	
	return [JMUSBMuxPacketFactory packetForDictionary:dictionary];
}

+(NSData *)validDetachPacket
{
	NSDictionary* dictionary = @{JMDictionaryKeyMessageType:JMMessageTypeDetached, JMDictionaryKeyDeviceID:@1};
	
	return [JMUSBMuxPacketFactory packetForDictionary:dictionary];
}

+(NSData *)invalidDetachPacket
{
	NSDictionary* dictionary = @{JMDictionaryKeyMessageType:JMMessageTypeDetached};
	
	return [JMUSBMuxPacketFactory packetForDictionary:dictionary];
}

+(NSData *)validResultPacket
{
	NSDictionary* dictionary = @{JMDictionaryKeyMessageType:JMMessageTypeResult, JMDictionaryKeyNumber:@1};
	
	return [JMUSBMuxPacketFactory packetForDictionary:dictionary];
}

+(NSData *)invalidResultPacket
{
	NSDictionary* dictionary = @{JMDictionaryKeyMessageType:JMMessageTypeResult};
	
	return [JMUSBMuxPacketFactory packetForDictionary:dictionary];
}

@end
