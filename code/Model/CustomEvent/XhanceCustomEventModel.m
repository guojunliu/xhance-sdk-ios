//
//  XhanceCustomEventModel.m
//  XhanceSDK
//
//  Created by liuguojun on 2018/8/29.
//  Copyright © 2018年 liuguojun. All rights reserved.
//

#import "XhanceCustomEventModel.h"
#import "NSMutableDictionary+XhanceCheckNullValue.h"

@implementation XhanceCustomEventModel

- (instancetype)initWithKey:(NSString *)key value:(NSObject *)value {
    self = [super initWithTimeStampAndUUID];
    if (self) {
        _key = [key copy];
        _value = value;
    }
    return self;
}

#pragma mark - Util

+ (NSDictionary *)convertDicWithModel:(XhanceCustomEventModel *)model {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [XhanceBaseModel convertToDic:dic withModel:model];
    
    [dic setCheckValue:model.key forKey:@"key"];
    [dic setCheckValue:model.value forKey:@"value"];
    
    return dic;
}

+ (XhanceCustomEventModel *)convertModelWithDic:(NSDictionary *)dic {
    XhanceCustomEventModel *model = [[XhanceCustomEventModel alloc] init];
    [XhanceBaseModel convertToModel:model withDic:dic];
    
    model.key = [dic objectForCheckKey:@"key"];
    model.value = [dic objectForCheckKey:@"value"];
    
    return model;
}

@end
