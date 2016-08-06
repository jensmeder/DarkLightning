//
//  JMDecodedSimpleDataPackets.h
//  DarkLightning
//
//  Created by Jens Meder on 06/08/16.
//
//

#import <Foundation/Foundation.h>
#import "JMSimpleDataPacket.h"

@interface JMDecodedSimpleDataPackets : NSObject

@property (nonnull, nonatomic, strong, readonly) NSData* rawData;
@property (nonnull, nonatomic, strong, readonly) NSArray<JMSimpleDataPacket*>* decodedMessages;

- (nonnull instancetype) initWithRawData:(nonnull NSData*)rawData andDecodedMessages:(nonnull NSArray<JMSimpleDataPacket*>*)decodedMessages NS_DESIGNATED_INITIALIZER;

- (nonnull instancetype) decodedMessagesByAppendingRawData:(nonnull NSData*)rawData;

@end
