//
//  JMRootViewController.h
//  DarkLightning
//
//  Created by Jens Meder on 07/11/15.
//  Copyright © 2015 Jens Meder. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JMRootViewModel.h"

@interface JMRootViewController : NSViewController

@property (nonnull, nonatomic, strong, readonly) JMRootViewModel* viewModel;

-(nonnull instancetype)initWithViewModel:(nonnull JMRootViewModel*)viewModel;

@end
