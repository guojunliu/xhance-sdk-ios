//
//  XhanceCustomEventParameter.h
//  XhanceSDK
//
//  Created by liuguojun on 2018/8/22.
//  Copyright © 2018年 liuguojun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XhanceBaseParameter.h"
#import "XhanceCustomEventModel.h"

@interface XhanceCustomEventParameter : XhanceBaseParameter

- (instancetype)initWithCustomEventModel:(XhanceCustomEventModel *)model;

@end
