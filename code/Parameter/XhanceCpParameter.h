//
//  XhanceCpParameter.h
//  XhanceSDK
//
//  Created by steve on 2018/5/17.
//  Copyright © 2018 Adrealm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XhanceCpParameter : NSObject

@property(nonatomic,copy) NSString *appId;
@property(nonatomic,copy) NSString *devKey;
@property(nonatomic,copy) NSString *publicKey;
@property(nonatomic,copy) NSString *trackUrl;
@property(nonatomic,copy) NSString *channelId;

+ (instancetype)shareinstance;

@end
