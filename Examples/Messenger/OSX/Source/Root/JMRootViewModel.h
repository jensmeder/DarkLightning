//
//  JMRootViewModel.h
//  DarkLightning
//
//  Created by Jens Meder on 14/11/15.
//  Copyright © 2015 Jens Meder. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JMRootViewModel;

@protocol JMRootViewModelDelegate <NSObject>

-(void) rootViewModel:(nonnull id<JMRootViewModel>)viewModel didConnectToDeviceWithName:(nonnull NSString*)name;
-(void) rootViewModelDidDisconnectFromDevice:(nonnull id<JMRootViewModel>)viewModel;
-(void) rootViewModel:(nonnull id<JMRootViewModel>)viewModel didReceiveMessage:(nonnull NSString*)message;

@end

@protocol JMRootViewModel<NSObject>

@property (nullable, nonatomic, weak) id<JMRootViewModelDelegate> delegate;

-(BOOL) sendMessage:(nonnull NSString*)message;

@end
