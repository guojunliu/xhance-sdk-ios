//
//  XhanceHttpUrl.h
//  XhanceSDK
//
//  Created by steve on 2018/5/15.
//  Copyright © 2018 Adrealm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XhanceBaseParameter.h"

@interface XhanceHttpUrl : NSObject

+ (instancetype)shareInstance;

#pragma mark - AdvertiserUrl

- (void)setAdvertiserUrl:(NSString *)advertiserlUrl;

- (NSString *)getAdvertiserUrl;

#pragma mark - InstallUrl

- (NSString *)getInstallUrlForAdvertiser;

- (NSString *)getInstallUrlForAdRealm;

#pragma mark - SessionUrl

- (NSString *)getSessionUrlForAdvertiser;

- (NSString *)getSessionUrlForAdRealm;

#pragma mark - IAPUrl

- (NSString *)getIAPUrlForAdvertiser;

- (NSString *)getIAPUrlForAdRealm;

#pragma mark - DeeplinkUrl

- (NSString *)getDeeplinkUrlForAdvertiser;

#pragma mark - jointUrl

+ (NSString *)jointAdvertiserUrl:(NSString *)url
                    aesEncodeKey:(NSString *)aesEncodeKey
          enDataStrForAdvertiser:(NSString *)enDataStrForAdvertiser
                  parameterModel:(XhanceBaseParameter *)parameterModel;

+ (NSString *)jointAdRealmUrl:(NSString *)url
            dataStrForAdRealm:(NSString *)dataStrForAdRealm
               parameterModel:(XhanceBaseParameter *)parameterModel;

#pragma mark - ParameterStr

+ (NSString *)getAdvertiserParameterStrWithAesEncodeKey:(NSString *)aesEncodeKey
                                 enDataStrForAdvertiser:(NSString *)enDataStrForAdvertiser
                                         parameterModel:(XhanceBaseParameter *)parameterModel;

+ (NSString *)getAdRealmParameterStrWithDataStrForAdRealm:(NSString *)dataStrForAdRealm
                                           parameterModel:(XhanceBaseParameter *)parameterModel;
@end
