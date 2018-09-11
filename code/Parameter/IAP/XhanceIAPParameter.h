//
//  XhanceIAPParameter.h
//  XhanceSDK
//
//  Created by liuguojun on 2018/5/29.
//  Copyright © 2018 Adrealm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XhanceBaseParameter.h"
#import "XhanceIAPModel.h"

@interface XhanceIAPParameter : XhanceBaseParameter

- (instancetype)initWithIAPModel:(XhanceIAPModel *)model;

@end
