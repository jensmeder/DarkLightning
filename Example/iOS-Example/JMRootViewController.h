//
//  JMRootViewController.h
//  DarkLightning
//
//  Created by Jens Meder on 06/11/15.
//  Copyright © 2015 Jens Meder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMRootViewModel.h"

@interface JMRootViewController : UIViewController

@property (nonnull, nonatomic, strong, readonly) JMRootViewModel* viewModel;

-(nonnull instancetype)initWithViewModel:(nonnull JMRootViewModel*)viewModel;

@end
