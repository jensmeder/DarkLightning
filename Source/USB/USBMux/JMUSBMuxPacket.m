//
//  JMUSBMuxPacket.m
//  DarkLightning
//
//  Created by Jens Meder on 21/08/16.
//
//

#import "JMUSBMuxPacket.h"

@implementation JMUSBMuxPacket

-(instancetype)init {
	
	return [self initWithHeader:[[JMUSBMuxPacketHeader alloc]init] andPayload:[NSData data]];
}

-(instancetype)initWithHeader:(JMUSBMuxPacketHeader *)header andPayload:(NSData *)payload {
	
	self = [super init];
	
	if (self) {
		
		_header = header;
		_payload = payload;
	}
	
	return self;
}

-(NSData *)encodedPacket {
	
	NSMutableData* data = _header.encodedHeader.mutableCopy;
	[data appendData:_payload];
	
	return data.copy;
}

@end
