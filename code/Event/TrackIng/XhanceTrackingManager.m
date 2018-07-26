//
//  KTrackingManager.m
//  testSafariVC
//
//  Created by steve on 16/7/6.
//  Copyright © 2018 Adrealm. All rights reserved.
//

#import "XhanceTrackingManager.h"
#import <SafariServices/SafariServices.h>
#import "NSMutableDictionary+XhanceCheckNullValue.h"
#import "XhanceUtil.h"
#import "XhanceRSA.h"
#import "XhanceAES.h"
#import "XhanceHttpUrl.h"
#import "XhanceTrackingParameter.h"
#import "XhanceDeeplinkManager.h"
#import <iAd/iAd.h>

#define IOS_IS_TRACKED @"ios_is_tracked"    // Has it been attributed

@interface XhanceTrackingManager () <SFSafariViewControllerDelegate>
{
    int _trackingNumber;
    
    NSString *_publicKey;   //RSA public key
    
    __block XhanceTrackingParameter *_parameter;
    
    NSString *_aesKey;                              // Globally unique AES encryption key, randomly generated
    NSString *_aesEncodeKey;                        // str is _aesKey encryption to RSA
}
@end

@implementation XhanceTrackingManager

static XhanceTrackingManager *manager;

#pragma mark - shareInstancetype

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(manager == nil) {
            manager = [[XhanceTrackingManager alloc] init];
        }
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _aesKey = [XhanceUtil get16RandomStr];
    }
    return self;
}

#pragma mark - API

- (void)trackingWithPublicKey:(NSString *)publicKey {
    if (publicKey == nil || [publicKey isEqualToString:@""]) {
        return;
    }
    
    _publicKey = [publicKey copy];
    
    // RSA encryption
    _aesEncodeKey = [XhanceRSA encryptString:_aesKey publicKey:_publicKey];
    
    BOOL isTracking = [[NSUserDefaults standardUserDefaults] boolForKey:IOS_IS_TRACKED];
    if (isTracking) {
        // Has been tracked
        return;
    }
    
    double version = [[UIDevice currentDevice].systemVersion doubleValue];
    if (version < 9.0f) {
        // Version below 9.0 is not track
        return;
    }

    // get apple search ad info
    [self getAppleSearchAdData:^(NSString *referrerStr) {
        _parameter = [[XhanceTrackingParameter alloc] initWithReferrer:referrerStr];
        [self trackingWithAdvertiser];
        [self trackingWithAdRealm];
    }];
}

- (void)getAppleSearchAdData:(void (^)(NSString *referrerStr))completionBlock {
    // Get parameters
    __block NSString *referrerJson = @"";
    if ([[ADClient sharedClient] respondsToSelector:@selector(requestAttributionDetailsWithBlock:)]) {
        [[ADClient sharedClient] requestAttributionDetailsWithBlock:^(NSDictionary *attributionDetails, NSError *error) {
            NSString *referrerStr = nil;
            if (error) {
                referrerStr = nil;
            }
            else {
                if (attributionDetails != nil) {
                    NSString *jsonStr = [XhanceUtil dictionaryToJson:attributionDetails];
                    referrerJson = [jsonStr copy];
                    if (referrerJson != nil && ![referrerJson isEqualToString:@""]) {
                        NSString *str = [NSString stringWithFormat:@"_apple_search:%@",referrerJson];
                        NSString *referrer = [XhanceUtil URLEncodedString:str];
                        referrerStr = [referrer copy];
                    }
                }
            }
            completionBlock(referrerStr);
        }];
    }
    else {
        completionBlock(nil);
    }
}

//Report to Advertiser
- (void)trackingWithAdvertiser {
    NSString *trackDataStrForAdvertiser = _parameter.dataStrForAdvertiser;
    NSString *enString = [XhanceAES EnAESandBase64EnToString:trackDataStrForAdvertiser key:_aesKey];
    NSString *urlStr = [[XhanceHttpUrl shareInstance] getInstallUrlForAdvertiser];
    NSString *jointParmeterUrlStr = [XhanceHttpUrl jointAdvertiserUrl:urlStr
                                                         aesEncodeKey:_aesEncodeKey
                                               enDataStrForAdvertiser:enString
                                                       parameterModel:_parameter];
    
    [self safariTrack:jointParmeterUrlStr];
}

//Report to AdRealm
- (void)trackingWithAdRealm {
    NSString *trackDataStrForAdRealm = _parameter.dataStrForAdRealm;
    NSString *urlStr = [[XhanceHttpUrl shareInstance] getInstallUrlForAdRealm];
    NSString *jointParameterUrlStr = [XhanceHttpUrl jointAdRealmUrl:urlStr
                                                  dataStrForAdRealm:trackDataStrForAdRealm
                                                     parameterModel:_parameter];
    
    [self safariTrack:jointParameterUrlStr];
}

#pragma mark - SafariTrackWithURL

// iOS 9.0 or above，use SFSafariViewController cookie to track
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
        
        [rootVC addChildViewController:safariVC];
        safariVC.view.frame = CGRectMake(100, 100, 0.1, 0.1);
        safariVC.view.backgroundColor = [UIColor whiteColor];
        [rootVC.view addSubview:safariVC.view];
    });
}

#pragma mark - SFSafariViewControllerDelegate

- (void)safariViewController:(SFSafariViewController *)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully {
    NSString *urlStr = controller.title;
    
    if (didLoadSuccessfully) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IOS_IS_TRACKED];
        [controller.view removeFromSuperview];
        [controller removeFromParentViewController];
        
        #ifdef UPLTVXhanceSDKDEBUG
            NSLog(@"[XhanceSDK Log] succeed:%@",urlStr);
        #endif
        
        // Delay 1s to request Deeplink from the server
        int time = 1;
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if ([XhanceDeeplinkManager canGetDeeplink]) {
                [XhanceDeeplinkManager getDeeplinkWithServer:_parameter];
            }
        });
    }
    else {
        [controller.view removeFromSuperview];
        [controller removeFromParentViewController];
        
        // max retry 3
//        if (_trackingNumber < 3)
//        {
            //if failure, retry after 10 seconds
            int time = 10;
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self safariTrack:urlStr];
            });
//        }
    }
}

@end
