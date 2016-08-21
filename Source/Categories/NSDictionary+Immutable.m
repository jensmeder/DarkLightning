//
//  NSDictionary+Immutable.m
//  DarkLightning
//
//  Created by Jens Meder on 21/08/16.
//
//

#import "NSDictionary+Immutable.h"

@implementation NSDictionary (Immutable)

- (nonnull instancetype) dictionaryBySettingValue:(nonnull id)value forKey:(nonnull id)key {
	
	NSMutableDictionary* dict = self.mutableCopy;
	dict[key] = value;
	
	return dict.copy;
}

-(instancetype)dictionaryByRemovingKey:(id)key {
	
	NSMutableDictionary* dict = self.mutableCopy;
	[dict removeObjectForKey:key];
	
	return dict.copy;
}

@end
