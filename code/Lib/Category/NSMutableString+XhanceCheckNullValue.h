//
//  NSMutableString+XhanceCheckNullValue.h
//  XhanceSDK
//
//  Created by steve on 2018/6/20.
//  Copyright © 2018 Adrealm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableString (XhanceCheckNullValue)

- (void)appendAndCheckString:(NSString *)aString;

@end
