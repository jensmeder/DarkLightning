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

@interface JMRootViewController () <NSOutlineViewDelegate, NSOutlineViewDataSource, JMRootViewModelDelegate, NSTextFieldDelegate>

@end

@implementation JMRootViewController
{
	@private
	
	__weak JMRootView* _rootView;
}

-(instancetype)initWithViewModel:(id<JMRootViewModel>)viewModel
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
	
	_rootView.messageTextField.placeholderString = @"Type a message here";
	self.view.window.title = @"Disconnected";
	
	NSToolbar* toolbar = [[NSToolbar alloc]initWithIdentifier:@"Toolbar"];
	
	self.view.window.toolbar = toolbar;
}

#pragma mark - Root View Model Delegate

-(void)rootViewModel:(id<JMRootViewModel>)viewModel didConnectToDeviceWithName:(NSString *)name
{
	self.view.window.title = [NSString stringWithFormat:@"Connected to %@",name];
}

-(void)rootViewModelDidDisconnectFromDevice:(id<JMRootViewModel>)viewModel
{
	self.view.window.title = @"Disconnected";
}

-(void)rootViewModel:(id<JMRootViewModel>)viewModel didReceiveMessage:(NSString *)message
{
	NSDateComponents* components = [[NSCalendar currentCalendar]components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:[NSDate date]];
	
	NSString* timeString = [NSString stringWithFormat:@"%02ld:%02ld:%02ld\r\n", (long) components.hour, (long) components.minute, (long)components.second];
	NSDictionary* timeAttributes = @{NSForegroundColorAttributeName: [NSColor lightGrayColor]};
	NSAttributedString* time = [[NSAttributedString alloc]initWithString:timeString attributes:timeAttributes];
	
	[_rootView.messageTextView.textStorage appendAttributedString:time];
	
	NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];

	paragraphStyle.paragraphSpacing = 8.0f;
	NSDictionary* messageAttributes = @{NSFontAttributeName: [NSFont systemFontOfSize:14.0], NSParagraphStyleAttributeName:paragraphStyle};
	NSAttributedString* messageString = [[NSAttributedString alloc]initWithString:[message stringByAppendingString:@"\r\n"] attributes:messageAttributes];
	
	[_rootView.messageTextView.textStorage appendAttributedString:messageString];
	
	[_rootView.messageTextView scrollToEndOfDocument:nil];
}

#pragma mark - Text Field Delegate

-(void)controlTextDidEndEditing:(NSNotification *)obj
{
	[_viewModel sendMessage:_rootView.messageTextField.stringValue];
	
	_rootView.messageTextField.stringValue = @"";
}

@end
