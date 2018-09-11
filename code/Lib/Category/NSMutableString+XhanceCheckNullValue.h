//
//  NSMutableString+XhanceCheckNullValue.h
//  XhanceSDK
//
//  Created by liuguojun on 2018/6/20.
//  Copyright © 2018 Adrealm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableString (XhanceCheckNullValue)

- (void)appendAndCheckString:(NSString *)aString;

@end
