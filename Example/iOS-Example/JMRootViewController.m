//
//  JMRootViewController.m
//  DarkLightning
//
//  Created by Jens Meder on 06/11/15.
//  Copyright © 2015 Jens Meder. All rights reserved.
//

#import "JMRootViewController.h"

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
