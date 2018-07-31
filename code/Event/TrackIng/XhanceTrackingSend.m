//
//  XhanceTrackingSend.m
//  XhanceSDK
//
//  Created by steve on 2018/7/30.
//  Copyright © 2018年 Adrealm. All rights reserved.
//

#import "XhanceTrackingSend.h"
#import <UIKit/UIKit.h>
#import <SafariServices/SafariServices.h>

#define IOS_TRACK_SEND_RETRY_NUMBER         (5)         // The maximum number of retries
#define IOS_TRACK_SEND_RETRY_DELAY_TIME     (10)        // The delay time

typedef void (^XhanceTrackingSendBlock)(BOOL didLoadSuccessfully);

@interface XhanceTrackingSend () <SFSafariViewControllerDelegate> {
    
    int _trackingSendRetryNumber;
    XhanceTrackingSendBlock _completionBlock;
}
@end

@implementation XhanceTrackingSend

- (instancetype)init {
    self = [super init];
    if (self) {
        _trackingSendRetryNumber = 0;
    }
    return self;
}

#pragma mark - SafariTrackWithURL

// iOS 9.0 or above，use SFSafariViewController cookie to track
- (void)safariTrack:(NSString *)urlStr completion:(void (^)(BOOL didLoadSuccessfully))completionBlock {
    
    _completionBlock = [completionBlock copy];
    
    [self safariTrack:urlStr];
}

- (void)safariTrack:(NSString *)urlStr {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        if (rootVC == nil) {
            //If rootVC is empty, it cannot be sent, and it will be retry after 5 seconds.
            int time = 5;
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self safariTrack:urlStr];
            });
            return;
        }
        
        // creat SFSafariViewController get cookie, and track
        SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:urlStr]];
        safariVC.title = urlStr;
        safariVC.delegate = self;
        safariVC.view.tag = 1;
        
        [rootVC addChildViewController:safariVC];
        safariVC.view.frame = CGRectMake(100, 100, 0.1, 0.1);
        safariVC.view.backgroundColor = [UIColor whiteColor];
        [rootVC.view addSubview:safariVC.view];
    });
}

#pragma mark - SFSafariViewControllerDelegate

- (void)safariViewController:(SFSafariViewController *)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully {
    NSString *urlStr = controller.title;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (didLoadSuccessfully) {
            [controller.view removeFromSuperview];
            [controller removeFromParentViewController];
            if (_completionBlock) {
                _completionBlock(YES);
            }
            return;
        }
        
        [controller.view removeFromSuperview];
        [controller removeFromParentViewController];
        
        //if failure, retry after 10 seconds
        if (_trackingSendRetryNumber < IOS_TRACK_SEND_RETRY_NUMBER) {
            _trackingSendRetryNumber += 1;
            int time = IOS_TRACK_SEND_RETRY_DELAY_TIME;
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                #ifdef UPLTVXhanceSDKDEBUG
                NSLog(@"[XhanceSDK Log] Tracking retry %i with url:%@",_trackingSendRetryNumber,urlStr);
                #endif
                
                [self safariTrack:urlStr];
            });
            
            return;
        }
        
        if (_completionBlock) {
            _completionBlock(NO);
        }
    });
}

@end
