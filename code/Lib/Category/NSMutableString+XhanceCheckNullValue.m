//
//  NSMutableString+XhanceCheckNullValue.m
//  XhanceSDK
//
//  Created by liuguojun on 2018/6/20.
//  Copyright © 2018 Adrealm. All rights reserved.
//

#import "NSMutableString+XhanceCheckNullValue.h"

@implementation NSMutableString (XhanceCheckNullValue)

- (void)appendAndCheckString:(NSString *)aString {
    
    if (aString == nil) {
        return;
    }
    [self appendString:aString];
}

@end
