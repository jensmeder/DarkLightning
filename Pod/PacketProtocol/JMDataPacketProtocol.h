//
//  JMDataPacketProtocol.h
//  Pods
//
//  Created by Jens Meder on 07/11/15.
//
//

#import <Foundation/Foundation.h>

@protocol JMDataPacketProtocol <NSObject>

-(nonnull NSData*) encodePacket:(nonnull NSData*)packet;
-(nonnull NSArray<NSData*>*) processData:(nonnull NSData*)data;
-(void) reset;

@end
