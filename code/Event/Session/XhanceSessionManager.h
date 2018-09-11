//
//  XhanceSessionManager.h
//  XhanceSDK
//
//  Created by liuguojun on 2018/5/14.
//  Copyright © 2018 Adrealm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XhanceSessionManager : NSObject

+ (instancetype)shareInstance;

#pragma mark - checkDefeatedSessionAndSendWithChildThread
- (void)checkDefeatedSessionAndSendWithChildThread;

#pragma mark - SessionId
- (NSString *)getCurrentSessionId;

@end
