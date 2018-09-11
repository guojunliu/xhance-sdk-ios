//
//  XhanceFileCache.h
//  XhanceSDK
//
//  Created by liuguojun on 2018/8/27.
//  Copyright © 2018年 liuguojun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, XhanceFileCachePathType) {
    XhanceFileCachePathTypeSession      = 0,
    XhanceFileCachePathTypeIAP          = 1,
    XhanceFileCachePathTypeCustomEvent  = 2,
};

typedef NS_ENUM (NSInteger, XhanceFileCacheChannelType) {
    XhanceFileCacheChannelTypeAdvertiser    = 0,
    XhanceFileCacheChannelTypeAdRealm       = 1,
};

@interface XhanceFileCache : NSObject

+ (instancetype)shareInstance;

- (void)writeDic:(NSDictionary *)dic channelType:(XhanceFileCacheChannelType)channelType pathType:(XhanceFileCachePathType)pathType;

- (void)removeDic:(NSDictionary *)dic channelType:(XhanceFileCacheChannelType)channelType pathType:(XhanceFileCachePathType)pathType;

- (NSArray <NSDictionary *> *)getArrayWithChannelType:(XhanceFileCacheChannelType)channelType pathType:(XhanceFileCachePathType)pathType;

@end
