//
//  JMNativeSocket.h
//  DarkLightning
//
//  Created by Jens Meder on 20/11/15.
//  Copyright © 2015 Jens Meder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import "JMSocket.h"

@interface JMNativeSocket : NSObject<JMSocket>

@property (readonly) CFSocketNativeHandle nativeSocket;

-(instancetype)initWithNativeSocket:(CFSocketNativeHandle)nativeSocket;

@end
