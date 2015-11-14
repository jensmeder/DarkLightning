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
{
	@private
	
	NSScrollView* _scrollView;
}

-(instancetype)initWithFrame:(NSRect)frameRect
{
	self = [super initWithFrame:frameRect];
	
	if (self)
	{
		[self addSubviews];
	}
	
	return self;
}

-(void) addSubviews
{
	_messageTextField = [[NSTextField alloc]init];
	_messageTextField.translatesAutoresizingMaskIntoConstraints = NO;
	_messageTextField.focusRingType = NSFocusRingTypeNone;
	_messageTextField.bezeled = YES;
	_messageTextField.bezelStyle = NSTextFieldRoundedBezel;
	[_messageTextField setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationVertical];
	
	_scrollView = [[NSScrollView alloc]init];
	_scrollView.translatesAutoresizingMaskIntoConstraints = NO;
	_scrollView.hasVerticalScroller = YES;
	[_scrollView setContentCompressionResistancePriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationHorizontal];
	
	_scrollView.contentView.autoresizingMask = NSViewHeightSizable;

	_messageTextView = [[NSTextView alloc] init];
	[_messageTextView setEditable:NO];
	[_messageTextView setVerticallyResizable:YES];
	[_messageTextView setHorizontallyResizable:YES];
	
	[self addSubview:_messageTextField];
	[self addSubview:_scrollView];
	_scrollView.documentView = _messageTextView;
	
	[self addSubviewConstraints];
}

-(void)addSubviewConstraints
{
	NSMutableArray<NSLayoutConstraint*>* constraints = [NSMutableArray array];
	
	NSArray* horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-5-[_messageTextField]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_messageTextField)];
	
	[constraints addObjectsFromArray:horizontalConstraints];
	
	horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-5-[_scrollView]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_scrollView)];
	
	[constraints addObjectsFromArray:horizontalConstraints];
	
	NSArray* verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_scrollView]-5-[_messageTextField]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_messageTextField, _scrollView)];
	
	[constraints addObjectsFromArray:verticalConstraints];
	
	// Add constraints
	
	for (NSLayoutConstraint* constraint in constraints)
	{
		constraint.active = YES;
	}
}

@end
