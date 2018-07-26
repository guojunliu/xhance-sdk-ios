//
//  XhanceParameter.h
//  XhanceSDK
//
//  Created by steve on 2018/5/17.
//  Copyright © 2018 Adrealm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XhanceBaseParameter.h"
#import "XhanceSessionModel.h"

@interface XhanceSessionParameter : XhanceBaseParameter

- (instancetype)initWithSession:(XhanceSessionModel *)session;

@end
