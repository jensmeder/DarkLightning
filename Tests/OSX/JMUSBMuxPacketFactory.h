//
//  JMUSBMuxPacketFactory.h
//  DarkLightning
//
//  Created by Jens Meder on 15/11/15.
//  Copyright © 2015 Jens Meder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMUSBMuxPacketFactory : NSObject

+(NSData*) validAttachPacket;
+(NSData*) invalidAttachPacket;

+(NSData*) validDetachPacket;
+(NSData*) invalidDetachPacket;

+(NSData*) validResultPacket;
+(NSData*) invalidResultPacket;

@end
