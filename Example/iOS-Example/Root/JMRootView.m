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

#import "JMRootView.h"

@implementation JMRootView

-(instancetype)init
{
	self = [super init];
	
	if (self)
	{
		self.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
		
		_sendMessageButton = [[UIButton alloc]init];
		_sendMessageButton.translatesAutoresizingMaskIntoConstraints = NO;
		[_sendMessageButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
		[_sendMessageButton setTitle:@"Send" forState:UIControlStateNormal];
		_sendMessageButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
		
		_sendMessageTextField = [[UITextField alloc]init];
		_sendMessageTextField.translatesAutoresizingMaskIntoConstraints = NO;
		[_sendMessageTextField setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
		_sendMessageTextField.backgroundColor = [UIColor whiteColor];
		_sendMessageTextField.borderStyle = UITextBorderStyleRoundedRect;
		_sendMessageTextField.placeholder = @"Your message";
		_sendMessageTextField.font = [UIFont systemFontOfSize:16.0];
		
		_messageLogTextView = [[UITextView alloc]init];
		_messageLogTextView.translatesAutoresizingMaskIntoConstraints = NO;
		[_messageLogTextView setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
		
		[self addSubview:_messageLogTextView];
		[self addSubview:_sendMessageTextField];
		[self addSubview:_sendMessageButton];
		
		
		NSMutableArray* constraints = [NSMutableArray array];
		
		NSArray* verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_messageLogTextView]-5-[_sendMessageTextField]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_sendMessageTextField, _messageLogTextView)];
		
		[constraints addObjectsFromArray:verticalConstraints];
		
		NSArray* horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[_messageLogTextView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_messageLogTextView)];
		
		[constraints addObjectsFromArray:horizontalConstraints];
		
		horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-5-[_sendMessageTextField]-5-[_sendMessageButton]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_sendMessageTextField, _sendMessageButton)];
		
		[constraints addObjectsFromArray:horizontalConstraints];
		
		[constraints addObject:[NSLayoutConstraint constraintWithItem:_sendMessageButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_sendMessageTextField attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
		
		for (NSLayoutConstraint* constraint in constraints)
		{
			constraint.active = YES;
		}
	}
	
	return self;
}

@end
