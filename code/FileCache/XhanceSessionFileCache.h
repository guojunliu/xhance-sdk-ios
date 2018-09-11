//
//  XhanceSessionFileCache.h
//  XhanceSDK
//
//  Created by liuguojun on 2018/5/17.
//  Copyright © 2018 Adrealm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XhanceSessionModel.h"

@interface XhanceSessionFileCache : NSObject

+ (instancetype)shareInstance;

#pragma mark - AdvertiserSession

- (void)writeAdvertiserSession:(XhanceSessionModel *)sessionModel;

- (void)removeAdvertiserSession:(XhanceSessionModel *)sessionModel;

- (NSArray <XhanceSessionModel *> *)getAdvertiserSessions;

#pragma mark - AdRealmSession

- (void)writeAdRealmSession:(XhanceSessionModel *)sessionModel;

- (void)removeAdRealmSession:(XhanceSessionModel *)sessionModel;

- (NSArray <XhanceSessionModel *> *)getAdRealmSessions;

@end
