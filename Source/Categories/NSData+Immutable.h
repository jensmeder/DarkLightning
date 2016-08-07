//
//  NSData+Immutable.h
//  DarkLightning
//
//  Created by Jens Meder on 06/08/16.
//
//

#import <Foundation/Foundation.h>

@interface NSData (Immutable)

-(nonnull instancetype) dataByAppendingData:(nonnull NSData*)data;

@end
