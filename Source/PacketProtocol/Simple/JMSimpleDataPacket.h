//
//  JMSimpleDataPacket.h
//  DarkLightning
//
//  Created by Jens Meder on 06/08/16.
//
//

#import <Foundation/Foundation.h>

@interface JMSimpleDataPacket : NSObject

@property (readonly) uint32_t length;
@property (nonnull, nonatomic, strong, readonly) NSData* payload;
@property (nonnull, nonatomic, copy, readonly) NSData* encodedPacket;

-(nonnull instancetype)initWithPayload:(nonnull NSData*)payload;
-(nonnull instancetype)initWithLength:(uint32_t)length andPayload:(nonnull NSData*)payload NS_DESIGNATED_INITIALIZER;

@end
