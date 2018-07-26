//
//  XhanceBaseParameter.h
//  XhanceSDK
//
//  Created by steve on 2018/5/28.
//  Copyright © 2018 Adrealm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XhanceUtil.h"
#import "XhanceMd5Utils.h"
#import "XhanceCpParameter.h"
#import "NSMutableDictionary+XhanceCheckNullValue.h"

@interface XhanceBaseParameter : NSObject

@property(nonatomic,copy) NSString *timeStamp;      //Timestamp, globally use this one to ensure that each API is unique

@property(nonatomic) NSMutableDictionary *dataForAdvertiser;    //Attribution data is sent to the advertiser
@property(nonatomic) NSMutableDictionary *dataForAdRealm;       //Attribution summary data sent to the AdRealm

@property(nonatomic,copy) NSString *dataStrForAdvertiser;       //Attribution data str is sent to the advertiser
@property(nonatomic,copy) NSString *dataStrForAdRealm;          //Attribution summary data str sent to the AdRealm

@property(nonatomic) NSMutableDictionary *baseParameterDic;     //Common parameter map

- (instancetype)initWithTimeStamp:(NSString *)timeStamp;

- (void)createDataForAdvertiser;

- (void)createDataForAdRealm;

#pragma mark - Util

- (NSString *)sortParameter:(NSMutableDictionary *)parameters;

@end
