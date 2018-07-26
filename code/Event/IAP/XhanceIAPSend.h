//
//  XhanceIAPSend.h
//  XhanceSDK
//
//  Created by steve on 2018/5/31.
//  Copyright © 2018 Adrealm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XhanceIAPParameter.h"

@interface XhanceIAPSend : NSObject

+ (void)sendAdvertiserIAP:(XhanceIAPParameter *)iapParameter;

+ (void)sendAdRealmIAP:(XhanceIAPParameter *)iapParameter;

@end
