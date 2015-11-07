//
//  JMRootViewModel.m
//  DarkLightning
//
//  Created by Jens Meder on 06/11/15.
//  Copyright © 2015 Jens Meder. All rights reserved.
//

#import "JMRootViewModel.h"

@interface JMRootViewModel () <JMMobileDevicePortDelegate>

@end

@implementation JMRootViewModel

-(instancetype)initWithDevicePort:(JMMobileDevicePort *)devicePort
{
	self = [super init];
	
	if (self)
	{
		_devicePort = devicePort;
	}
	
	return self;
}

#pragma mark - Delegate

-(void)mobileDevicePort:(JMMobileDevicePort *)port didChangeState:(JMMobileDevicePortState)state
{
	
}

-(void)mobileDevicePort:(JMMobileDevicePort *)port didReceiveData:(NSData *)data
{
	
}

@end
