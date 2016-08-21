//
//  NSDictionary+Immutable.h
//  DarkLightning
//
//  Created by Jens Meder on 21/08/16.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary<__covariant KeyType, __covariant ObjectType> (Immutable)

- (nonnull instancetype) dictionaryBySettingValue:(nonnull ObjectType)value forKey:(nonnull KeyType)key;
- (nonnull instancetype) dictionaryByRemovingKey:(nonnull KeyType)key;

@end
