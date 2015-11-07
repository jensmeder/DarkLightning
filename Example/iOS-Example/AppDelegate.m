//
//  AppDelegate.m
//  iOS-Example
//
//  Created by Jens Meder on 06/11/15.
//  Copyright © 2015 Jens Meder. All rights reserved.
//

#import "AppDelegate.h"
#import <DarkLightning/JMMobileDevicePort.h>
#import "JMRootViewModel.h"
#import "JMRootViewController.h"

@implementation AppDelegate
{
	@private
	
	UIWindow* _mainWindow;
	JMMobileDevicePort* _devicePort;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	_devicePort = [[JMMobileDevicePort alloc]initWithPort:2347];
	
	JMRootViewModel* viewModel = [[JMRootViewModel alloc]initWithDevicePort:_devicePort];
	JMRootViewController* viewController = [[JMRootViewController alloc]initWithViewModel:viewModel];
	UINavigationController* navigationController = [[UINavigationController alloc]initWithRootViewController:viewController];
	
	_mainWindow = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
	_mainWindow.rootViewController = navigationController;
	[_mainWindow makeKeyAndVisible];
	
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	[_devicePort close];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	[_devicePort close];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	[_devicePort open];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	
	[_devicePort open];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	
	[_devicePort close];
}

@end
