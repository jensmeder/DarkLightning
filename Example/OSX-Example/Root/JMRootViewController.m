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

@interface JMRootViewController () <NSOutlineViewDelegate, NSOutlineViewDataSource, JMRootViewModelDelegate>

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
	JMRootView* rootView = [[JMRootView alloc]initWithFrame:NSMakeRect(0, 0, 400, 400)];
	
	
	
	
	
	_rootView = rootView;
	
	
	
	
	
	self.view = rootView;
}

-(void)viewWillAppear
{
	[super viewWillAppear];
	
	NSTableColumn *tc = [[NSTableColumn alloc] initWithIdentifier:@"blah"];

	_rootView.deviceListView.indentationPerLevel = 0;
	
	_rootView.deviceListView.delegate = self;
	_rootView.deviceListView.dataSource = self;
	
	[_rootView.deviceListView addTableColumn:tc];
	
	[_rootView.deviceListView sizeLastColumnToFit];
	_rootView.deviceListView.floatsGroupRows = NO;
	
	[_rootView.deviceListView reloadData];
	
	[_rootView.deviceListView.headerView setNeedsDisplay:YES];
	
	[_rootView.deviceListView expandItem:JMRootViewControllerDeviceListHeaderTitle];
}

#pragma mark - Root View Model Delegate

-(void)rootViewModel:(JMRootViewModel *)viewModel didAttachDeviceAtIndex:(NSUInteger)index
{
	[_rootView.deviceListView reloadData];
}

-(void)rootViewModel:(JMRootViewModel *)viewModel didDetachDeviceAtIndex:(NSUInteger)index
{
	[_rootView.deviceListView reloadData];
}

#pragma mark - Table View Data source

-(BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
	return ![item isEqualToString:JMRootViewControllerDeviceListHeaderTitle];
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
	if (!item)
	{
		return JMRootViewControllerDeviceListHeaderTitle;
	}
	
	return [_viewModel nameOfDeviceAtIndex:0];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
	if ([item isEqualToString:JMRootViewControllerDeviceListHeaderTitle])
	{
		return YES;
	}
	
	return NO;
}

-(BOOL)outlineView:(NSOutlineView *)outlineView shouldShowOutlineCellForItem:(id)item
{
	return NO;
}

-(BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
	if ([item isEqualToString:JMRootViewControllerDeviceListHeaderTitle])
	{
		return YES;
	}
	
	return NO;
}

- (NSInteger) outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
	if ([item isEqualToString:JMRootViewControllerDeviceListHeaderTitle])
	{
		return _viewModel.numberOfDevices;
	}
	
	return 1;
}

-(NSTableRowView *)outlineView:(NSOutlineView *)outlineView rowViewForItem:(id)item
{
	return [[NSTableRowView alloc]init];
}

-(NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
	NSTextField *result = [[NSTextField alloc]init];
	result.bordered = NO;
	result.backgroundColor = [NSColor clearColor];
	
	result.stringValue = item;
	
	return result;
}

@end
