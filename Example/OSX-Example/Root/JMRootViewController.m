/**
 *	The MIT License (MIT)
 *
 *	Copyright (c) 2015 Jens Meder
 *
 *	Permission is hereby granted, free of charge, to any person obtaining a copy of
 *	this software and associated documentation files (the "Software"), to deal in
 *	the Software without restriction, including without limitation the rights to
 *	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 *	the Software, and to permit persons to whom the Software is furnished to do so,
 *	subject to the following conditions:
 *
 *	The above copyright notice and this permission notice shall be included in all
 *	copies or substantial portions of the Software.
 *
 *	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 *	FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 *	COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 *	IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 *	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "JMRootViewController.h"
#import "JMRootView.h"

static NSString* const JMRootViewControllerDeviceListHeaderTitle = @"DEVICES";

@interface JMRootViewController () <NSOutlineViewDelegate, NSOutlineViewDataSource, JMRootViewModelDelegate, NSTextFieldDelegate>

@end

@implementation JMRootViewController
{
	@private
	
	__weak JMRootView* _rootView;
}

-(instancetype)initWithViewModel:(JMRootViewModel *)viewModel
{
	self = [super init];
	
	if (self)
	{
		_viewModel = viewModel;
		_viewModel.delegate = self;
	}
	
	return self;
}

-(void)loadView
{
	JMRootView* rootView = [[JMRootView alloc]initWithFrame:NSMakeRect(0, 0, 600, 400)];
	_rootView = rootView;
	_rootView.messageTextField.delegate = self;

	self.view = rootView;
}

-(void)viewWillAppear
{
	[super viewWillAppear];
	
	self.view.window.title = @"Disconnected";
}

#pragma mark - Root View Model Delegate

-(void)rootViewModel:(JMRootViewModel *)viewModel didConnectToDeviceWithName:(nonnull NSString *)name
{
	self.view.window.title = [NSString stringWithFormat:@"Connected to %@",name];
}

-(void)rootViewModelDidDisconnectFromDevice:(JMRootViewModel *)viewModel
{
	self.view.window.title = @"Disconnected";
}

-(void)rootViewModel:(JMRootViewModel *)viewModel didReceiveMessage:(NSString *)message
{
	_rootView.messageTextView.string = [NSString stringWithFormat:@"%@\r\n%@", _rootView.messageTextView.string, message];
	[_rootView.messageTextView scrollToEndOfDocument:nil];
}

#pragma mark - Text Field Delegate

-(void)controlTextDidEndEditing:(NSNotification *)obj
{
	[_viewModel sendMessage:_rootView.messageTextField.stringValue];
	
	_rootView.messageTextField.stringValue = @"";
}

@end
