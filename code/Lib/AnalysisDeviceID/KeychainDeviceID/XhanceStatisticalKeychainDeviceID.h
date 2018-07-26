//
//  KeychainIDFA.h
//  KeychainIDFA
//
//  Created by Qixin on 14/12/18.
//  Copyright (c) 2018 Adrealm. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IDFA_STRING @"com.UPLTV.XhanceSDK"

@interface XhanceStatisticalKeychainDeviceID : NSObject

+ (NSString *)deviceID;

@end
