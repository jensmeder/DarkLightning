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
	_deviceListView = [[NSOutlineView alloc]init];
	_deviceListView.translatesAutoresizingMaskIntoConstraints = NO;
	_deviceListView.columnAutoresizingStyle = NSTableViewUniformColumnAutoresizingStyle;
	
	[self addSubview:_deviceListView];
	
	[self addSubviewConstraints];
}

-(void)addSubviewConstraints
{
	NSMutableArray<NSLayoutConstraint*>* constraints = [NSMutableArray array];
	
	// Content Hugging and compression
	
	[_deviceListView setContentHuggingPriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationVertical];
	[_deviceListView setContentHuggingPriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationHorizontal];
	
	// Vertical constraints
	
	NSArray* verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_deviceListView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_deviceListView)];
	
	[constraints addObjectsFromArray:verticalConstraints];
	
	// Horizontal constraints
	
	NSArray* horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[_deviceListView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_deviceListView)];
	
	[constraints addObjectsFromArray:horizontalConstraints];
	
	// Add constraints
	
	for (NSLayoutConstraint* constraint in constraints)
	{
		constraint.active = YES;
	}
}

@end
