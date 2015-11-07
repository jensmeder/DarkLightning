//
//  AppDelegate.m
//  OSX-Example
//
//  Created by Jens Meder on 06/11/15.
//  Copyright © 2015 Jens Meder. All rights reserved.
//

#import "AppDelegate.h"
#import "JMRootViewModel.h"
#import "JMRootViewController.h"
#import <DarkLightning/JMUSBDeviceManager.h>

@implementation AppDelegate
{
	@private
	
	NSWindow* _mainWindow;
	JMUSBDeviceManager* _deviceManager;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	_deviceManager = [[JMUSBDeviceManager alloc]init];
	
	JMRootViewModel* viewModel = [[JMRootViewModel alloc]initWithDeviceManager:_deviceManager];
	JMRootViewController* viewController = [[JMRootViewController alloc]initWithViewModel:viewModel];
	
	_mainWindow = [[NSWindow alloc]initWithContentRect:NSMakeRect(40, -500, 400, 400) styleMask:NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask backing:NSBackingStoreBuffered defer:YES];
	_mainWindow.contentViewController = viewController;
	
	[_mainWindow makeKeyAndOrderFront:nil];
	
	[_deviceManager start];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
	[_deviceManager stop];
}

@end
