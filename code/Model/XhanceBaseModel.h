//
//  XhanceBaseModel.h
//  XhanceSDK
//
//  Created by liuguojun on 2018/8/28.
//  Copyright © 2018年 liuguojun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XhanceBaseModel : NSObject

@property (nonatomic) NSDate *timeStamp;
@property (nonatomic,copy) NSString *uuid;

- (instancetype)initWithTimeStampAndUUID;

+ (void)convertToDic:(NSMutableDictionary *)dic withModel:(XhanceBaseModel *)model;

+ (void)convertToModel:(XhanceBaseModel *)model withDic:(NSDictionary *)dic;

@end
