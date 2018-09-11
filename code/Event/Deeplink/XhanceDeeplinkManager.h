//
//  XhanceDeeplinkManager.h
//  XhanceSDK
//
//  Created by liuguojun on 2018/6/1.
//  Copyright © 2018 Adrealm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XhanceTrackingParameter.h"
#import "XhanceDeeplinkModel.h"

@interface XhanceDeeplinkManager : NSObject

+ (BOOL)canGetDeeplink;

+ (void)getDeeplinkWithServer:(XhanceTrackingParameter *)parameter;

+ (void)getDeeplink:(void (^)(XhanceDeeplinkModel *deeplinkModel))completionBlock;

@end
