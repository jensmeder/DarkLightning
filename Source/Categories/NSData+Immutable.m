//
//  NSData+Immutable.m
//  DarkLightning
//
//  Created by Jens Meder on 06/08/16.
//
//

#import "NSData+Immutable.h"

@implementation NSData (Immutable)

-(instancetype)dataByAppendingData:(NSData *)data {
	
	NSMutableData* buffer = [[NSMutableData alloc]initWithCapacity:self.length + data.length];
	[buffer appendData:self];
	[buffer appendData:data];
	
	return buffer.copy;
}

@end
