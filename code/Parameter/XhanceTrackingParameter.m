//
//  XhanceTrackingParameter.m
//  XhanceSDK
//
//  Created by steve on 2018/5/17.
//  Copyright © 2018 Adrealm. All rights reserved.
//

#import "XhanceTrackingParameter.h"
#import <iAd/iAd.h>

@interface XhanceTrackingParameter () {
    NSString *_referrer;
}
@end

@implementation XhanceTrackingParameter

- (instancetype)initWithReferrer:(NSString *)referrer {
    NSString *timeStamp = [XhanceUtil getDateTimeStamp];
    self = [super initWithTimeStamp:timeStamp];
    if (self) {
        _referrer = [referrer copy];
        [self createDataForAdvertiser];
        [self createDataForAdRealm];
    }
    return self;
}

- (void)createDataForAdvertiser {
    
    if (_referrer != nil) {
        [self.dataForAdvertiser setCheckObject:_referrer forKey:@"referrer"];
    }
    
    [super createDataForAdvertiser];
}

- (void)createDataForAdRealm {
    [super createDataForAdRealm];
}

@end
