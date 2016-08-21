//
//  JMUSBMuxPacketHeader.m
//  DarkLightning
//
//  Created by Jens Meder on 21/08/16.
//
//

#import "JMUSBMuxPacketHeader.h"

@implementation JMUSBMuxPacketHeader

-(instancetype)init {
	
	return [self initWithPayloadSize:0 protocolType:0 packetType:0 tag:0];
}

-(instancetype)initWithData:(NSData *)data {
	
	uint32_t packetSize = 0;
	uint32_t protocolType = 0;
	uint32_t packetType = 0;
	uint32_t tag = 0;
	
	[data getBytes:&packetSize range:NSMakeRange(0, 4)];
	[data getBytes:&protocolType range:NSMakeRange(4, 4)];
	[data getBytes:&packetType range:NSMakeRange(8, 4)];
	[data getBytes:&tag range:NSMakeRange(12, 4)];
	
	return [self initWithPayloadSize:packetSize - 16 protocolType:protocolType packetType:packetType tag:tag];
}

-(instancetype)initWithPayloadSize:(uint32_t)payloadSize protocolType:(JMUSBMuxPacketProtocolType)protocolType packetType:(JMUSBMuxPacketType)packetType tag:(uint32_t)tag {
	
	self = [super init];
	
	if (self) {
		
		_payloadSize = payloadSize;
		_protocolType = protocolType;
		_packetType = packetType;
		_tag = tag;
	}
	
	return self;
}

-(NSData *)encodedHeader {
	
	uint32_t packetSize = _payloadSize + 16;
	
	NSMutableData* data = [NSMutableData data];
	[data appendBytes:&packetSize length:4];
	[data appendBytes:&_protocolType length:4];
	[data appendBytes:&_packetType length:4];
	[data appendBytes:&_tag length:4];
	
	return data.copy;
}

@end
