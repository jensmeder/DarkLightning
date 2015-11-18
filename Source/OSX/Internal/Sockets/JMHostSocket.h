//
//  JMHostSocket.h
//  DarkLightning
//
//  Created by Jens Meder on 18/11/15.
//  Copyright © 2015 Jens Meder. All rights reserved.
//

#import "JMSocket.h"

@interface JMHostSocket : NSObject<JMSocket>

@property (readonly) uint32_t port;
@property (nonnull, nonatomic, strong, readonly) NSString* host;

-(nullable instancetype)initWithHost:(nonnull NSString*)host andPort:(uint32_t)port;

@end
