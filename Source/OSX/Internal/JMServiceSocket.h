//
//  JMServiceSocket.h
//  DarkLightning
//
//  Created by Jens Meder on 18/11/15.
//  Copyright © 2015 Jens Meder. All rights reserved.
//

#import "JMSocket.h"

@interface JMServiceSocket : NSObject<JMSocket>

@property (nonnull, nonatomic, strong, readonly) NSString* path;

-(nullable instancetype)initWithPath:(nonnull NSString*)path;

@end
