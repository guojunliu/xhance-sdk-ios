//
//  XhanceCustomEventSend.m
//  XhanceSDK
//
//  Created by liuguojun on 2018/8/22.
//  Copyright © 2018年 liuguojun. All rights reserved.
//

#import "XhanceCustomEventSend.h"
#import "XhanceRSA.h"
#import "XhanceAES.h"
#import "XhanceHttpUrl.h"
#import "XhanceHttpManager.h"
#import "XhanceFileCache.h"

@implementation XhanceCustomEventSend

+ (void)sendAdvertiserCustomEvent:(XhanceCustomEventModel *)model {
    NSString *aesKey = [XhanceUtil get16RandomStr];
    NSString *aesEncodeKey = [XhanceRSA encryptString:aesKey publicKey:[XhanceCpParameter shareinstance].publicKey];
    XhanceCustomEventParameter *customEventParameter = [[XhanceCustomEventParameter alloc] initWithCustomEventModel:model];
    // The main parameters
    NSString *dataStrForAdvertiser = customEventParameter.dataStrForAdvertiser;
    
    // AES encryption
    NSString *enString = [XhanceAES EnAESandBase64EnToString:dataStrForAdvertiser key:aesKey];
    
    // Get the domain name path url
    NSString *urlStr = [[XhanceHttpUrl shareInstance] getCustomEventUrlForAdvertiser];
    
    // Stitching parameter into url
    NSString *jointParmeterUrlStr = [XhanceHttpUrl jointAdvertiserUrl:urlStr
                                                         aesEncodeKey:aesEncodeKey
                                               enDataStrForAdvertiser:enString
                                                       parameterModel:customEventParameter];
    
    [XhanceHttpManager sendCustomEventForAdvertiser:jointParmeterUrlStr retryCount:0 completion:^(id responseObject) {
        NSDictionary *dic = [XhanceCustomEventModel convertDicWithModel:model];
        [[XhanceFileCache shareInstance] removeDic:dic
                                       channelType:XhanceFileCacheChannelTypeAdvertiser
                                          pathType:XhanceFileCachePathTypeCustomEvent];
    } error:^(NSError *error) {}];
}

+ (void)sendAdRealmCustomEvent:(XhanceCustomEventModel *)model {
    XhanceCustomEventParameter *customEventParameter = [[XhanceCustomEventParameter alloc] initWithCustomEventModel:model];
    // The main parameters
    NSString *dataStrForAdRealm = customEventParameter.dataStrForAdRealm;
    
    // Get the domain name path url
    NSString *urlStr = [[XhanceHttpUrl shareInstance] getCustomEventUrlForAdRealm];
    
    // Stitching parameter into url
    NSString *jointParameterUrlStr = [XhanceHttpUrl jointAdRealmUrl:urlStr
                                                  dataStrForAdRealm:dataStrForAdRealm
                                                     parameterModel:customEventParameter];
    
    [XhanceHttpManager sendCustomEventForAdRealm:jointParameterUrlStr retryCount:0 completion:^(id responseObject) {
        NSDictionary *dic = [XhanceCustomEventModel convertDicWithModel:model];
        [[XhanceFileCache shareInstance] removeDic:dic
                                       channelType:XhanceFileCacheChannelTypeAdRealm
                                          pathType:XhanceFileCachePathTypeCustomEvent];
    } error:^(NSError *error) {}];
}

@end
