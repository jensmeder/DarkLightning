//
//  JMSimulatorConnection.h
//  Pods
//
//  Created by Jens Meder on 07/11/15.
//
//

#import <Foundation/Foundation.h>
#import "JMDeviceConnection.h"

@interface JMSimulatorConnection : JMDeviceConnection

@property (nonnull, nonatomic, strong, readonly) NSString* host;

-(nullable instancetype)initWithHost:(nonnull NSString*)host andPort:(uint32_t)port;

@end
