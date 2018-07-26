//
//  XhanceSessionModel.m
//  XhanceSDK
//
//  Created by steve on 2018/5/14.
//  Copyright © 2018 Adrealm. All rights reserved.
//

#import "XhanceSessionModel.h"

@implementation XhanceSessionModel

#pragma mark - init

- (instancetype)initWithSessionId:(NSString *)sessionId type:(XhanceSessionModelType)type {
    self = [super self];
    if (self) {
        _sessionID = sessionId;
        _clientTime = [NSDate date];
        _dataType = type;
    }
    return self;
}

#pragma mark - Util

+ (NSDictionary *)convertDicWithModel:(XhanceSessionModel *)model {
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    NSString *sessionID = [model.sessionID copy];
    NSDate *clientTime = model.clientTime;
    XhanceSessionModelType dataType = model.dataType;
    if (sessionID != nil) {
        [dic setObject:sessionID forKey:@"sessionID"];
    }
    if (clientTime != nil) {
        [dic setObject:clientTime forKey:@"clientTime"];
    }
    if (dataType == XhanceSessionModelTypeStart
        || dataType == XhanceSessionModelTypeTimer
        || dataType == XhanceSessionModelTypeEnd) {
        NSString *strDataType = [NSString stringWithFormat:@"%i",(int)dataType];
        [dic setObject:strDataType forKey:@"dataType"];
    }
    
    return dic;
}

+ (XhanceSessionModel *)convertModelWithDic:(NSDictionary *)dic {
    XhanceSessionModel *model = [[XhanceSessionModel alloc] init];
    if ([[dic allKeys] containsObject:@"sessionID"]) {
        model.sessionID = [dic objectForKey:@"sessionID"];
    }
    if ([[dic allKeys] containsObject:@"clientID"]) {
        model.clientTime = [dic objectForKey:@"clientID"];
    }
    if ([[dic allKeys] containsObject:@"dataType"]) {
        NSString *strDataType = [dic objectForKey:@"dataType"];
        model.dataType = strDataType.intValue;
    }
    return model;
}

@end
