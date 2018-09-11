//
//  XhanceCustomEventSend.h
//  XhanceSDK
//
//  Created by liuguojun on 2018/8/22.
//  Copyright © 2018年 liuguojun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XhanceCustomEventParameter.h"
#import "XhanceCustomEventModel.h"

@interface XhanceCustomEventSend : NSObject

+ (void)sendAdvertiserCustomEvent:(XhanceCustomEventModel *)customEventParameter;

+ (void)sendAdRealmCustomEvent:(XhanceCustomEventModel *)customEventParameter;

@end
