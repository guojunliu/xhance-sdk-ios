//
//  XhanceIAPManager.m
//  XhanceSDK
//
//  Created by liuguojun on 2018/5/30.
//  Copyright © 2018 Adrealm. All rights reserved.
//

#import "XhanceIAPManager.h"
#import "XhanceIAPSend.h"
#import "XhanceIAPParameter.h"
#import "XhanceIAPModel.h"
#import "XhanceFileCache.h"

@interface XhanceIAPManager ()

@end

@implementation XhanceIAPManager

+ (void)appStoreWithProductPrice:(NSNumber *)productPrice
             productCurrencyCode:(NSString *)productCurrencyCode
               receiptDataString:(NSString *)receiptDataString
                          pubkey:(NSString *)pubkey
                          params:(NSDictionary *)params {
    XhanceIAPModel *model = [[XhanceIAPModel alloc] initWithProductPrice:productPrice
                                                     productCurrencyCode:productCurrencyCode
                                                       productIdentifier:@""
                                                         productCategory:@""
                                                       receiptDataString:receiptDataString
                                                                  pubkey:pubkey
                                                                  params:params
                                                              isThirdPay:NO];
    [self sendModel:model];
}

+ (void)thirdPayWithProductPrice:(NSNumber *)productPrice
             productCurrencyCode:(NSString *)productCurrencyCode
               productIdentifier:(NSString *)productIdentifier
                 productCategory:(NSString *)productCategory {
    XhanceIAPModel *model = [[XhanceIAPModel alloc] initWithProductPrice:productPrice
                                                     productCurrencyCode:productCurrencyCode
                                                       productIdentifier:productIdentifier
                                                         productCategory:productCategory
                                                       receiptDataString:@""
                                                                  pubkey:@""
                                                                  params:nil
                                                              isThirdPay:YES];
    [self sendModel:model];
}

#pragma mark - CacheModel

+ (void)cacheModel:(XhanceIAPModel *)model {
    // Write session model to file chache
    NSDictionary *sessionDic = [XhanceIAPModel convertDicWithModel:model];
    [[XhanceFileCache shareInstance] writeDic:sessionDic
                                  channelType:XhanceFileCacheChannelTypeAdvertiser
                                     pathType:XhanceFileCachePathTypeIAP];
    [[XhanceFileCache shareInstance] writeDic:sessionDic
                                  channelType:XhanceFileCacheChannelTypeAdRealm
                                     pathType:XhanceFileCachePathTypeIAP];
}

#pragma mark - sendModel

+ (void)sendModel:(XhanceIAPModel *)model {
    [self cacheModel:model];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self sendAdvertiserIAP:model];
        [self sendAdRealmIAP:model];
    });
}

+ (void)sendAdvertiserIAP:(XhanceIAPModel *)model {
    [XhanceIAPSend sendAdvertiserIAP:model];
}

+ (void)sendAdRealmIAP:(XhanceIAPModel *)model {
    [XhanceIAPSend sendAdRealmIAP:model];
}

#pragma mark - checkDefeatedIAPAndSend

+ (void)checkDefeatedIAPAndSend {
    // Get the advertiser model that failed to send before and send.
    NSArray *defeatedAdvertiserIAPDics = [[XhanceFileCache shareInstance] getArrayWithChannelType:XhanceFileCacheChannelTypeAdvertiser
                                                                                                 pathType:XhanceFileCachePathTypeIAP];
    for (int i = 0; i < defeatedAdvertiserIAPDics.count; i++) {
        NSDictionary *IAPDic = [defeatedAdvertiserIAPDics objectAtIndex:i];
        XhanceIAPModel *IAPModel = [XhanceIAPModel convertModelWithDic:IAPDic];
        if (IAPModel == nil) {
            continue;
        }
        [self sendAdvertiserIAP:IAPModel];
    }
    
    // Get the adRealm model that failed to send before and send.
    NSArray *defeatedAdRealmIAPDics = [[XhanceFileCache shareInstance] getArrayWithChannelType:XhanceFileCacheChannelTypeAdRealm
                                                                                              pathType:XhanceFileCachePathTypeIAP];
    for (int i = 0; i < defeatedAdRealmIAPDics.count; i++) {
        NSDictionary *IAPDic = [defeatedAdRealmIAPDics objectAtIndex:i];
        XhanceIAPModel *IAPModel = [XhanceIAPModel convertModelWithDic:IAPDic];
        if (IAPModel == nil) {
            continue;
        }
        [self sendAdRealmIAP:IAPModel];
    }
}

+ (void)checkDefeatedIAPAndSendWithChildThread {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self checkDefeatedIAPAndSend];
    });
}

@end
