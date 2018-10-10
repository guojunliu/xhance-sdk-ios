//
//  XhanceCustomEventManager.h
//  XhanceSDK
//
//  Created by liuguojun on 2018/8/22.
//  Copyright © 2018年 liuguojun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XhanceCustomEventManager : NSObject

+ (void)enableCustomerEvent:(BOOL)enable;

+ (void)customEventWithKey:(NSString *)key value:(NSObject *)value;

+ (void)checkDefeatedCustomEventAndSendWithChildThread;

@end
