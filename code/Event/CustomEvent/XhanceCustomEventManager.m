//
//  XhanceCustomEventManager.m
//  XhanceSDK
//
//  Created by liuguojun on 2018/8/22.
//  Copyright © 2018年 liuguojun. All rights reserved.
//

#import "XhanceCustomEventManager.h"
#import "XhanceCustomEventSend.h"
#import "XhanceCustomEventParameter.h"
#import "XhanceFileCache.h"

BOOL CustomEventOpen;

@implementation XhanceCustomEventManager

+ (void)enableCustomerEvent:(BOOL)enable {
    CustomEventOpen = enable;
}

+ (void)customEventWithKey:(NSString *)key value:(NSObject *)value {
    
    if (!CustomEventOpen) {
        NSLog(@"[XhanceSDK Log Warning] SDK cannot use custom events. Please check!");
        return;
    }
    
    XhanceCustomEventModel *model = [[XhanceCustomEventModel alloc] initWithKey:key value:value];
    [self sendModel:model];
}

#pragma mark - CacheModel

+ (void)cacheModel:(XhanceCustomEventModel *)model {
    // Write customEvent model to file chache
    NSDictionary *customEventDic = [XhanceCustomEventModel convertDicWithModel:model];
    [[XhanceFileCache shareInstance] writeDic:customEventDic
                                  channelType:XhanceFileCacheChannelTypeAdvertiser
                                     pathType:XhanceFileCachePathTypeCustomEvent];
    [[XhanceFileCache shareInstance] writeDic:customEventDic
                                  channelType:XhanceFileCacheChannelTypeAdRealm
                                     pathType:XhanceFileCachePathTypeCustomEvent];
}

#pragma mark - sendModel

+ (void)sendModel:(XhanceCustomEventModel *)model {
    [self cacheModel:model];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self sendAdvertiserCustomEvent:model];
        [self sendAdRealmCustomEvent:model];
    });
}

+ (void)sendAdvertiserCustomEvent:(XhanceCustomEventModel *)model {
    [XhanceCustomEventSend sendAdvertiserCustomEvent:model];
}

+ (void)sendAdRealmCustomEvent:(XhanceCustomEventModel *)model {
    [XhanceCustomEventSend sendAdRealmCustomEvent:model];
}

#pragma mark - checkDefeatedCustomEventAndSend

+ (void)checkDefeatedCustomEventAndSend {
    // Get the advertiser model that failed to send before and send.
    NSArray *defeatedAdvertiserCustomEventDics = [[XhanceFileCache shareInstance] getArrayWithChannelType:XhanceFileCacheChannelTypeAdvertiser
                                                                                             pathType:XhanceFileCachePathTypeCustomEvent];
    for (int i = 0; i < defeatedAdvertiserCustomEventDics.count; i++) {
        NSDictionary *customEventDic = [defeatedAdvertiserCustomEventDics objectAtIndex:i];
        XhanceCustomEventModel *customEventModel = [XhanceCustomEventModel convertModelWithDic:customEventDic];
        if (customEventModel == nil) {
            continue;
        }
        [self sendAdvertiserCustomEvent:customEventModel];
    }
    
    // Get the adRealm model that failed to send before and send.
    NSArray *defeatedAdRealmCustomEventDics = [[XhanceFileCache shareInstance] getArrayWithChannelType:XhanceFileCacheChannelTypeAdRealm
                                                                                          pathType:XhanceFileCachePathTypeCustomEvent];
    for (int i = 0; i < defeatedAdRealmCustomEventDics.count; i++) {
        NSDictionary *customEventDic = [defeatedAdRealmCustomEventDics objectAtIndex:i];
        XhanceCustomEventModel *customEventModel = [XhanceCustomEventModel convertModelWithDic:customEventDic];
        if (customEventModel == nil) {
            continue;
        }
        [self sendAdRealmCustomEvent:customEventModel];
    }
}

+ (void)checkDefeatedCustomEventAndSendWithChildThread {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self checkDefeatedCustomEventAndSend];
    });
}

@end
