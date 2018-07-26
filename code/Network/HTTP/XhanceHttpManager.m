//
//  XhanceHttpManager.m
//  XhanceSDK
//
//  Created by steve on 2018/4/12.
//  Copyright © 2018 Adrealm. All rights reserved.
//

#import "XhanceHttpManager.h"
#import "XhanceHttpSession.h"
#import "XhanceHttpUrl.h"
#import "XhanceSessionParameter.h"

@implementation XhanceHttpManager

#define K_RETRY_DELAY_TIME  (10)
#define K_RETRY_MAX_COUNT   (10)

#pragma mark - Session

+ (void)sendSessionForAdvertiser:(NSString *)url
                      retryCount:(int)retryCount
                      completion:(void (^)(id responseObject))completionBlock
                           error:(void (^)(NSError *error))errorBlock {
    
    [XhanceHttpSession HTTPPostWithUrl:url completion:^(id responseObject) {
        completionBlock(responseObject);
    } error:^(NSError *error) {
        if (retryCount <= K_RETRY_MAX_COUNT) {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(K_RETRY_DELAY_TIME * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self sendSessionForAdvertiser:url
                                    retryCount:retryCount + 1
                                    completion:completionBlock
                                         error:errorBlock];
            });
        }
        else {
            errorBlock(error);
        }
    }];
}

+ (void)sendSessionForAdRealm:(NSString *)url
                   retryCount:(int)retryCount
                   completion:(void (^)(id responseObject))completionBlock
                        error:(void (^)(NSError *error))errorBlock {
    
    [XhanceHttpSession HTTPPostWithUrl:url completion:^(id responseObject) {
        completionBlock(responseObject);
    } error:^(NSError *error) {
        if (retryCount <= K_RETRY_MAX_COUNT) {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(K_RETRY_DELAY_TIME * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self sendSessionForAdRealm:url
                                 retryCount:retryCount + 1
                                 completion:completionBlock
                                      error:errorBlock];
            });
        }
        else {
            errorBlock(error);
        }
    }];
}

#pragma mark - IAP

+ (void)sendIAPForAdvertiser:(NSString *)url
                parameterStr:(NSString *)parameterStr
                  retryCount:(int)retryCount
                  completion:(void (^)(id responseObject))completionBlock
                       error:(void (^)(NSError *error))errorBlock {
    
    [XhanceHttpSession HTTPPostWithUrl:url parameterStr:parameterStr completion:^(id responseObject) {
        completionBlock(responseObject);
    } error:^(NSError *error) {
        if (retryCount <= K_RETRY_MAX_COUNT) {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(K_RETRY_DELAY_TIME * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self sendIAPForAdvertiser:url
                              parameterStr:parameterStr
                                retryCount:retryCount + 1
                                completion:completionBlock
                                     error:errorBlock];
            });
        }
        else {
            errorBlock(error);
        }
    }];
}

+ (void)sendIAPForAdRealm:(NSString *)url
             parameterStr:(NSString *)parameterStr
               retryCount:(int)retryCount
               completion:(void (^)(id responseObject))completionBlock
                    error:(void (^)(NSError *error))errorBlock {
    
    [XhanceHttpSession HTTPPostWithUrl:url parameterStr:parameterStr completion:^(id responseObject) {
        completionBlock(responseObject);
    } error:^(NSError *error) {
        if (retryCount <= K_RETRY_MAX_COUNT) {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(K_RETRY_DELAY_TIME * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self sendIAPForAdRealm:url
                           parameterStr:parameterStr
                             retryCount:retryCount + 1
                             completion:completionBlock
                                  error:errorBlock];
            });
        }
        else {
            errorBlock(error);
        }
    }];
}

#pragma mark - DeepLink

+ (void)getDeepLink:(NSString *)url
         retryCount:(int)retryCount
         completion:(void (^)(id responseObject))completionBlock
              error:(void (^)(NSError *error))errorBlock {
    
    [XhanceHttpSession HTTPPostWithUrl:url completion:^(id responseObject) {
        completionBlock(responseObject);
    } error:^(NSError *error) {
        if (retryCount <= K_RETRY_MAX_COUNT) {
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(K_RETRY_DELAY_TIME * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self getDeepLink:url
                       retryCount:retryCount + 1
                       completion:completionBlock
                            error:errorBlock];
            });
        }
        else {
            errorBlock(error);
        }
    }];
}

@end
