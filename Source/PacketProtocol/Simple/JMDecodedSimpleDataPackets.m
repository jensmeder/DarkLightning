//
//  JMDecodedSimpleDataPackets.m
//  DarkLightning
//
//  Created by Jens Meder on 06/08/16.
//
//

#import "JMDecodedSimpleDataPackets.h"
#import "NSData+Immutable.h"

@implementation JMDecodedSimpleDataPackets

-(instancetype)init {
	
	return [self initWithRawData:[NSData data] andDecodedMessages:@[]];
}

-(instancetype)initWithRawData:(NSData *)rawData andDecodedMessages:(NSArray<JMSimpleDataPacket *> *)decodedMessages {
	
	self = [super init];
	
	if (self) {
		
		_rawData = rawData;
		_decodedMessages = decodedMessages;
	}
	
	return self;
}

-(instancetype)decodedMessagesByAppendingRawData:(NSData *)rawData {
	
	NSData* data = [_rawData dataByAppendingData:rawData];
	NSArray<JMSimpleDataPacket*>* decodedMessages = @[];
	
	uint32_t length = 0;
	
	if (data.length >= sizeof(length))
	{
		[data getBytes:&length length:sizeof(length)];
		length = CFSwapInt32BigToHost(length);
		
		while (sizeof(length) + length <= data.length)
		{
			NSData* payload = [data subdataWithRange:NSMakeRange(sizeof(length), length)];
			JMSimpleDataPacket* packet = [[JMSimpleDataPacket alloc]initWithLength:length andPayload:payload];
			decodedMessages = [decodedMessages arrayByAddingObject:packet];
			
			data = [data subdataWithRange:NSMakeRange(sizeof(length) + length, data.length - sizeof(length) + length)];
			[data getBytes:&length length:sizeof(length)];
			length = CFSwapInt32BigToHost(length);
		}
	}
	
	return [[JMDecodedSimpleDataPackets alloc]initWithRawData:data andDecodedMessages:decodedMessages];
}

@end
