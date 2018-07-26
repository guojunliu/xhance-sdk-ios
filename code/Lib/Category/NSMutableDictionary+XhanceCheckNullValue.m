//
//  NSMutableDictionary+XhanceCheckKeyAndValue.m
//  HolaStatistical
//
//  Created by steve on 2016/12/27.
//  Copyright © 2018 Adrealm. All rights reserved.
//

#import "NSMutableDictionary+XhanceCheckNullValue.h"

@implementation NSMutableDictionary (XhanceCheckKeyAndValue)

- (void)setCheckValue:(id)value forKey:(NSString *)key {
    if (key == nil) {
        return;
    }
    
    if (value == nil) {
        [self setValue:@"" forKey:key];
    }
    else {
       [self setValue:value forKey:key];
    }
}

- (void)setCheckObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (aKey == nil) {
        return;
    }
    
    if (anObject == nil) {
        [self setObject:@"" forKey:aKey];
    }
    else {
        [self setObject:anObject forKey:aKey];
    }
}

@end
