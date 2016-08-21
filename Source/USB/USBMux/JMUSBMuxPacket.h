//
//  JMUSBMuxPacket.h
//  DarkLightning
//
//  Created by Jens Meder on 21/08/16.
//
//

#import <Foundation/Foundation.h>
#import "JMUSBMuxPacketHeader.h"

@interface JMUSBMuxPacket : NSObject

@property (nonnull, nonatomic, strong, readonly) JMUSBMuxPacketHeader* header;
@property (nonnull, nonatomic, strong, readonly) NSData* payload;

@property (nonnull, nonatomic, copy, readonly) NSData* encodedPacket;

-(nonnull instancetype)initWithHeader:(nonnull JMUSBMuxPacketHeader*)header andPayload:(nonnull NSData*)payload NS_DESIGNATED_INITIALIZER;

@end
