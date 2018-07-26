//
//  XhanceIAPSend.m
//  XhanceSDK
//
//  Created by steve on 2018/5/31.
//  Copyright © 2018 Adrealm. All rights reserved.
//

#import "XhanceIAPSend.h"
#import "XhanceSessionFileCache.h"
#import "XhanceHttpManager.h"
#import "XhanceAES.h"
#import "XhanceIAPParameter.h"
#import "XhanceHttpUrl.h"
#import "XhanceUtil.h"
#import "XhanceRSA.h"
#import "XhanceCpParameter.h"

@implementation XhanceIAPSend

+ (void)sendAdvertiserIAP:(XhanceIAPParameter *)iapParameter {
    NSString *aesKey = [XhanceUtil get16RandomStr];
    NSString *aesEncodeKey = [XhanceRSA encryptString:aesKey publicKey:[XhanceCpParameter shareinstance].publicKey];
    // The main parameters
    NSString *dataStrForAdvertiser = iapParameter.dataStrForAdvertiser;
    
    // AES encryption
    NSString *enString = [XhanceAES EnAESandBase64EnToString:dataStrForAdvertiser key:aesKey];
    
    // Get the domain name path url
    NSString *urlStr = [[XhanceHttpUrl shareInstance] getIAPUrlForAdvertiser];
    
    // Stitching ahs into url
    NSString *ahs = [XhanceMd5Utils MD5OfString:[XhanceCpParameter shareinstance].appId];
    urlStr = [NSString stringWithFormat:@"%@/%@",urlStr,ahs];
    
    // Because IAP parameters are longer, the parameters are placed in the body of the post.
    NSString *parameterStr = [XhanceHttpUrl getAdvertiserParameterStrWithAesEncodeKey:aesEncodeKey
                                                               enDataStrForAdvertiser:enString
                                                                       parameterModel:iapParameter];
    [XhanceHttpManager sendIAPForAdvertiser:urlStr
                               parameterStr:parameterStr
                                 retryCount:0
                                 completion:^(id responseObject) {}
                                      error:^(NSError *error) {}];
}

+ (void)sendAdRealmIAP:(XhanceIAPParameter *)iapParameter {
    // The main parameters
    NSString *dataStrForAdRealm = iapParameter.dataStrForAdRealm;
    
    // Get the domain name path url
    NSString *urlStr = [[XhanceHttpUrl shareInstance] getIAPUrlForAdRealm];
    // Stitching ahs into url
    NSString *ahs = [XhanceMd5Utils MD5OfString:[XhanceCpParameter shareinstance].appId];
    urlStr = [NSString stringWithFormat:@"%@/%@",urlStr,ahs];
    
    // Because IAP parameters are longer, the parameters are placed in the body of the post.
    NSString *parameterStr = [XhanceHttpUrl getAdRealmParameterStrWithDataStrForAdRealm:dataStrForAdRealm
                                                                         parameterModel:iapParameter];
    [XhanceHttpManager sendIAPForAdRealm:urlStr
                            parameterStr:parameterStr
                              retryCount:0
                              completion:^(id responseObject) {}
                                   error:^(NSError *error) {}];
}

@end
