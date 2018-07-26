//
//  NSMutableDictionary+XhanceCheckKeyAndValue.h
//  HolaStatistical
//
//  Created by steve on 2016/12/27.
//  Copyright © 2018 Adrealm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (XhanceCheckKeyAndValue)

- (void)setCheckValue:(id)value forKey:(NSString *)key;

- (void)setCheckObject:(id)anObject forKey:(id<NSCopying>)aKey;

@end
