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
	NSView* _borderView;
}

-(instancetype)initWithFrame:(NSRect)frameRect
{
	self = [super initWithFrame:frameRect];
	
	if (self)
	{
		CALayer *viewLayer = [CALayer layer];
		[viewLayer setBackgroundColor:CGColorCreateGenericRGB(1.0, 1.0, 1.0, 1.0)];
		[self setWantsLayer:YES];
		[self setLayer:viewLayer];
		
		[self addSubviews];
	}
	
	return self;
}

-(instancetype)init
{
	return [self initWithFrame:NSZeroRect];
}

-(NSTextField*) buildTextField
{
	NSTextField* textField = [[NSTextField alloc]init];
	
	textField.translatesAutoresizingMaskIntoConstraints = NO;
	textField.focusRingType = NSFocusRingTypeNone;
	textField.bezeled = NO;
	textField.font = [NSFont systemFontOfSize:14.0];

	[textField setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationVertical];
	
	return textField;
}

-(NSTextView*) buildTextView
{
	NSTextView* textView = [[NSTextView alloc] init];
	
	[textView setEditable:NO];
	[textView setVerticallyResizable:YES];
	[textView setHorizontallyResizable:YES];
	textView.font = [NSFont systemFontOfSize:14.0];
	
	return textView;
}

-(NSScrollView*) buildScrollView:(NSView*)documentView
{
	NSScrollView* scrollView = [[NSScrollView alloc]init];
	
	scrollView.translatesAutoresizingMaskIntoConstraints = NO;
	scrollView.hasVerticalScroller = YES;
	[scrollView setContentCompressionResistancePriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationHorizontal];
	scrollView.contentView.autoresizingMask = NSViewHeightSizable;
	scrollView.documentView = documentView;
	
	return scrollView;
}

-(NSView*) buildBorderView
{
	NSView* view = [[NSView alloc]init];
	view.translatesAutoresizingMaskIntoConstraints = NO;
	CALayer *viewLayer = [CALayer layer];
	[viewLayer setBackgroundColor:CGColorCreateGenericRGB(0.8, 0.8, 0.8, 1.0)];
	[view setWantsLayer:YES];
	[view setLayer:viewLayer];
	
	return view;
}

-(void) addSubviews
{
	_messageTextField = [self buildTextField];
	_messageTextView = [self buildTextView];
	_scrollView = [self buildScrollView:_messageTextView];
	_borderView = [self buildBorderView];
	
	[self addSubview:_messageTextField];
	[self addSubview:_scrollView];
	[self addSubview:_borderView];
	
	[self addSubviewConstraints];
}

-(void)addSubviewConstraints
{
	NSMutableArray<NSLayoutConstraint*>* constraints = [NSMutableArray array];
	
	NSArray* horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-20-[_messageTextField]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_messageTextField)];
	
	[constraints addObjectsFromArray:horizontalConstraints];
	
	horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[_scrollView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_scrollView)];
	
	[constraints addObjectsFromArray:horizontalConstraints];
	
	horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-20-[_borderView]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_borderView)];
	
	[constraints addObjectsFromArray:horizontalConstraints];
	
	NSArray* verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_scrollView]-5-[_borderView(1)]-20-[_messageTextField]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_messageTextField, _scrollView, _borderView)];
	
	[constraints addObjectsFromArray:verticalConstraints];
	
	// Add constraints
	
	for (NSLayoutConstraint* constraint in constraints)
	{
		constraint.active = YES;
	}
}

@end
