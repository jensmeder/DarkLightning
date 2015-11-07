//
//  JMRootViewController.m
//  DarkLightning
//
//  Created by Jens Meder on 07/11/15.
//  Copyright © 2015 Jens Meder. All rights reserved.
//

#import "JMRootViewController.h"
#import "JMRootView.h"

@interface JMRootViewController ()

@end

@implementation JMRootViewController

-(instancetype)initWithViewModel:(JMRootViewModel *)viewModel
{
	self = [super init];
	
	if (self)
	{
		_viewModel = viewModel;
	}
	
	return self;
}

-(void)loadView
{
	JMRootView* rootView = [[JMRootView alloc]initWithFrame:NSMakeRect(0, 0, 400, 400)];
	
	self.view = rootView;
}

@end
