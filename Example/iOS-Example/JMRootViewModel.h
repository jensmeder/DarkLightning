//
//  JMRootViewModel.h
//  DarkLightning
//
//  Created by Jens Meder on 06/11/15.
//  Copyright © 2015 Jens Meder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DarkLightning/JMMobileDevicePort.h>

@interface JMRootViewModel : NSObject

@property (nonnull, nonatomic, strong, readonly) JMMobileDevicePort* devicePort;

-(nonnull instancetype)initWithDevicePort:(nonnull JMMobileDevicePort*)devicePort;

@end
