//
//  XhanceSessionSend.m
//  XhanceSDK
//
//  Created by liuguojun on 2018/5/17.
//  Copyright © 2018 Adrealm. All rights reserved.
//

#import "XhanceSessionSend.h"
#import "XhanceFileCache.h"
#import "XhanceHttpManager.h"
#import "XhanceAES.h"
#import "XhanceSessionParameter.h"
#import "XhanceHttpUrl.h"
#import "XhanceUtil.h"
#import "XhanceRSA.h"
#import "XhanceCpParameter.h"

@implementation XhanceSessionSend

+ (void)sendAdvertiserSession:(XhanceSessionModel *)sessionModel {
    NSString *aesKey = [XhanceUtil get16RandomStr];
    NSString *aesEncodeKey = [XhanceRSA encryptString:aesKey publicKey:[XhanceCpParameter shareinstance].publicKey];
    XhanceSessionParameter *sessionParameter = [[XhanceSessionParameter alloc] initWithSession:sessionModel];
    // The main parameters
    NSString *dataStrForAdvertiser = sessionParameter.dataStrForAdvertiser;
    
    // AES encryption
    NSString *enString = [XhanceAES EnAESandBase64EnToString:dataStrForAdvertiser key:aesKey];
    
    // Get the domain name path url
    NSString *urlStr = [[XhanceHttpUrl shareInstance] getSessionUrlForAdvertiser];
    
    // Stitching parameter into url
    NSString *jointParmeterUrlStr = [XhanceHttpUrl jointAdvertiserUrl:urlStr
                                                         aesEncodeKey:aesEncodeKey
                                               enDataStrForAdvertiser:enString
                                                       parameterModel:sessionParameter];
    
    [XhanceHttpManager sendSessionForAdvertiser:jointParmeterUrlStr retryCount:0 completion:^(id responseObject) {
        NSDictionary *sessionDic = [XhanceSessionModel convertDicWithModel:sessionModel];
        [[XhanceFileCache shareInstance] removeDic:sessionDic
                                       channelType:XhanceFileCacheChannelTypeAdvertiser
                                          pathType:XhanceFileCachePathTypeSession];
    } error:^(NSError *error) {
    }];
}

+ (void)sendAdRealmSession:(XhanceSessionModel *)sessionModel {
    XhanceSessionParameter *sessionParameter = [[XhanceSessionParameter alloc] initWithSession:sessionModel];
    // The main parameters
    NSString *dataStrForAdRealm = sessionParameter.dataStrForAdRealm;
    
    // Get the domain name path url
    NSString *urlStr = [[XhanceHttpUrl shareInstance] getSessionUrlForAdRealm];
    
    // Stitching parameter into url
    NSString *jointParameterUrlStr = [XhanceHttpUrl jointAdRealmUrl:urlStr
                                                  dataStrForAdRealm:dataStrForAdRealm
                                                     parameterModel:sessionParameter];
    
    [XhanceHttpManager sendSessionForAdRealm:jointParameterUrlStr retryCount:0 completion:^(id responseObject) {
        NSDictionary *sessionDic = [XhanceSessionModel convertDicWithModel:sessionModel];
        [[XhanceFileCache shareInstance] removeDic:sessionDic
                                       channelType:XhanceFileCacheChannelTypeAdRealm
                                          pathType:XhanceFileCachePathTypeSession];
    } error:^(NSError *error) {
    }];
}

@end
