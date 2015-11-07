//
//  JMRootViewModel.h
//  DarkLightning
//
//  Created by Jens Meder on 07/11/15.
//  Copyright © 2015 Jens Meder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DarkLightning/JMUSBDeviceManager.h>

@interface JMRootViewModel : NSObject

@property (nonnull, nonatomic, strong, readonly) JMUSBDeviceManager* deviceManager;

-(nonnull instancetype)initWithDeviceManager:(nonnull JMUSBDeviceManager*)deviceManager;

@end
