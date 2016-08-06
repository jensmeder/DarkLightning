//
//  JMSimpleDataPacket.m
//  DarkLightning
//
//  Created by Jens Meder on 06/08/16.
//
//

#import "JMSimpleDataPacket.h"

@implementation JMSimpleDataPacket

-(instancetype)init {
	
	return [self initWithLength:0 andPayload:[NSData data]];
}

-(nonnull instancetype)initWithPayload:(nonnull NSData*)payload {
	
	return [self initWithLength:(uint32_t)payload.length andPayload:payload];
}

-(instancetype)initWithLength:(uint32_t)length andPayload:(NSData *)payload {
	
	self = [super init];
	
	if (self) {
		
		_length = length;
		_payload = payload;
	}
	
	return self;
}

#pragma mark - Properties

-(NSData *)encodedPacket {
	
	uint32_t packetLength = CFSwapInt32HostToBig(_length);
	
	NSMutableData* data = [NSMutableData dataWithBytes:&packetLength length:sizeof(uint32_t)];
	[data appendData:_payload];
	
	return data.copy;
}

@end
