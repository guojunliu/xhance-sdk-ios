//
//  XhanceBase64Utils.m
//  XhanceSDK
//
//  Created by steve on 2018/6/29.
//  Copyright © 2018 Adrealm. All rights reserved.
//

#import "XhanceBase64Utils.h"

@implementation XhanceBase64Utils

+ (NSString *)base64OfString:(NSString *)text {
    if (text == nil) {
        return @"";
    }
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [data base64EncodedStringWithOptions:0];
    return str;
}

@end
