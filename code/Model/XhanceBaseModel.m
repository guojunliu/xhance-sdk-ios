//
//  XhanceBaseModel.m
//  XhanceSDK
//
//  Created by liuguojun on 2018/8/28.
//  Copyright © 2018年 liuguojun. All rights reserved.
//

#import "XhanceBaseModel.h"
#import "XhanceMd5Utils.h"
#import "NSMutableDictionary+XhanceCheckNullValue.h"

@implementation XhanceBaseModel

- (instancetype)initWithTimeStampAndUUID {
    self = [super init];
    if (self) {
        _timeStamp = [NSDate date];
        _uuid = [XhanceMd5Utils MD5OfString:[NSUUID UUID].UUIDString];
    }
    return self;
}

#pragma mark - Util

+ (void)convertToDic:(NSMutableDictionary *)dic withModel:(XhanceBaseModel *)model {
    [dic setCheckValue:model.timeStamp forKey:@"timeStamp"];
    [dic setCheckValue:model.uuid forKey:@"uuid"];
}

+ (void)convertToModel:(XhanceBaseModel *)model withDic:(NSDictionary *)dic {
    model.timeStamp = [dic objectForCheckKey:@"timeStamp"];
    model.uuid = [dic objectForCheckKey:@"uuid"];
}

@end
