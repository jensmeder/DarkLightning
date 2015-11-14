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

@interface JMRootViewController () <UITextFieldDelegate, JMRootViewModelDelegate>

@end

@implementation JMRootViewController
{
	@private
	
	__weak JMRootView* _rootView;
	NSArray* _connectionStates;
	NSLayoutConstraint* _bottomConstraint;
}

-(instancetype)initWithViewModel:(id<JMRootViewModel>)viewModel
{
	if(!viewModel)
	{
		return nil;
	}
		
	self = [super init];
	
	if (self)
	{
		_viewModel = viewModel;
		_viewModel.delegate = self;
		_connectionStates = @[@"Disconnected",
							  @"Waiting for connection",
							  @"Connected"];
	}
	
	return self;
}

-(void)loadView
{
	UIView* containerView = [[UIView alloc]init];
	self.view = containerView;
	
	JMRootView* rootView = [[JMRootView alloc]init];
	_rootView = rootView;
	_rootView.translatesAutoresizingMaskIntoConstraints = NO;
	
	[containerView addSubview:rootView];
	
	NSMutableArray<NSLayoutConstraint*>* constraints = [NSMutableArray array];
	
	// Vertical Constraints
	
	[constraints addObject:[NSLayoutConstraint constraintWithItem:rootView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
	_bottomConstraint = [NSLayoutConstraint constraintWithItem:rootView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
	[constraints addObject:_bottomConstraint];
	
	// Horizontal Constraints
	
	NSArray<NSLayoutConstraint*>* horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[rootView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(rootView)];
	[constraints addObjectsFromArray:horizontalConstraints];
	
	for (NSLayoutConstraint* constraint in constraints)
	{
		constraint.active = YES;
	}
}

-(void)viewDidLoad
{
	[super viewDidLoad];
	
	[_rootView.sendMessageButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
	[_rootView.sendMessageTextField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
	_rootView.sendMessageTextField.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self updateTitle];
	[self updateButton];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification
											   object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
												 name:UIKeyboardDidShowNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
												 name:UIKeyboardDidHideNotification
											   object:nil];
}

- (void)keyboardWillShow: (NSNotification *) notification
{
	NSValue* rect = notification.userInfo[UIKeyboardFrameEndUserInfoKey];
	CGRect frame = rect.CGRectValue;
	
	[UIView animateWithDuration:0.25 animations:
	 ^{
		 _bottomConstraint.constant = -frame.size.height;
		 
		 [self.view layoutIfNeeded];
	}];
}

- (void)keyboardWillHide: (NSNotification *) notification
{
	[UIView animateWithDuration:0.25 animations:
	 ^{
		 _bottomConstraint.constant = 0;
		 
		 [self.view layoutIfNeeded];
	 }];
}

-(void) textDidChange:(UITextField*)textField
{
	_viewModel.message = textField.text;
}

-(void) sendMessage:(UIButton*)button
{
	[_viewModel sendMessage];
	_rootView.sendMessageTextField.text = nil;
}

#pragma mark - Internal

-(void) updateButton
{
	BOOL connected = _viewModel.connectionState == JMRootViewModelConnectionStateConnected ? YES: NO;
	_rootView.sendMessageButton.enabled = connected;
}

-(void) updateTitle
{
	self.title = _connectionStates[_viewModel.connectionState];
}

#pragma mark - Text field delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (_viewModel.connectionState != JMRootViewModelConnectionStateConnected)
	{
		return NO;
	}
	
	[self sendMessage:_rootView.sendMessageButton];
	
	return YES;
}

#pragma mark - Root View Model Delegate

-(void)rootViewModel:(id<JMRootViewModel>)viewModel didChangeConnectionState:(JMRootViewModelConnectionState)state
{
	[self updateTitle];
	[self updateButton];
}

-(void)rootViewModel:(id<JMRootViewModel>)viewModel didReceiveMessage:(NSString *)message
{
	_rootView.messageLogTextView.text = [NSString stringWithFormat:@"%@\r\n%@", _rootView.messageLogTextView.text, message];
	
	[_rootView.messageLogTextView.layoutManager ensureLayoutForTextContainer:_rootView.messageLogTextView.textContainer];
	
	CGFloat yOffset = _rootView.messageLogTextView.contentSize.height - _rootView.messageLogTextView.frame.size.height;
	
	if (yOffset > -_rootView.messageLogTextView.contentInset.top)
	{
		[_rootView.messageLogTextView setContentOffset:CGPointMake(0.0, yOffset) animated:YES];
	}
}


@end
