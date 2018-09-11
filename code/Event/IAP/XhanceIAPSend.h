//
//  XhanceIAPSend.h
//  XhanceSDK
//
//  Created by liuguojun on 2018/5/31.
//  Copyright © 2018 Adrealm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XhanceIAPParameter.h"

@interface XhanceIAPSend : NSObject

+ (void)sendAdvertiserIAP:(XhanceIAPModel *)iapModel;

+ (void)sendAdRealmIAP:(XhanceIAPModel *)iapModel;

@end
