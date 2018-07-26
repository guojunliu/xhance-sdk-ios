//
//  XhanceSessionSend.h
//  XhanceSDK
//
//  Created by steve on 2018/5/17.
//  Copyright © 2018 Adrealm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XhanceSessionModel.h"

@interface XhanceSessionSend : NSObject

+ (void)sendAdvertiserSession:(XhanceSessionModel *)sessionModel;

+ (void)sendAdRealmSession:(XhanceSessionModel *)sessionModel;

@end
