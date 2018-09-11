//
//  XhanceTrackingSend.h
//  XhanceSDK
//
//  Created by liuguojun on 2018/7/30.
//  Copyright © 2018年 Adrealm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XhanceTrackingSend : NSObject

- (void)safariTrack:(NSString *)urlStr completion:(void (^)(BOOL didLoadSuccessfully))completionBlock;

@end
