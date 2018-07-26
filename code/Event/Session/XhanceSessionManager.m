//
//  XhanceSessionManager.m
//  XhanceSDK
//
//  Created by steve on 2018/5/14.
//  Copyright © 2018 Adrealm. All rights reserved.
//

#import "XhanceSessionManager.h"
#import <UIKit/UIKit.h>
#import "XhanceSessionModel.h"
#import "XhanceMd5Utils.h"
#import "XhanceSessionFileCache.h"
#import "XhanceSessionSend.h"

#define TIMER_SESSION_INTERVAL      (300)
#define START_SESSION_MIN_INTERVAL  (300)
#define END_SESSION_MIN_INTERVAL    (300)

@interface XhanceSessionManager ()
{
    NSString *_sessionId;
    NSTimer *_timer;
    NSDate *_lastStartSessionDate;
    NSDate *_lastEndSessionDate;
}
@end

@implementation XhanceSessionManager

static XhanceSessionManager *manager;

#pragma mark - shareInstancetype

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(manager == nil) {
            manager = [[XhanceSessionManager alloc] init];
        }
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self listenApplicationDidBecomeActive];
        [self listenApplicationWillResignActive];
        
        // In order to prevent the cp initialization time from being delayed,
        // the UIApplicationDidBecomeActiveNotification notification cannot be received in time,
        // which causes the _timer to fail to initialize. Therefore, the _timer (10s) is initialized in the init.
        if (_timer != nil) {
            [_timer invalidate];
            _timer = nil;
        }
        _timer = [NSTimer timerWithTimeInterval:10
                                         target:self
                                       selector:@selector(timerSession)
                                       userInfo:nil
                                        repeats:NO];
        
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    return self;
}

#pragma mark - Notification

// The listening application becomes active
- (void)listenApplicationDidBecomeActive {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

// The listening application becomes inactive
- (void)listenApplicationWillResignActive {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
}

// becomes active
- (void)becomeActive {
    #ifdef UPLTVXhanceSDKDEBUG
        NSLog(@"[XhanceSDK Log] AppDelegate applicationDidBecomeActive  ---Become active---");
    #endif
    
    [self startSession];
}

// becomes inactive
- (void)resignActive {
    #ifdef UPLTVXhanceSDKDEBUG
        NSLog(@"[XhanceSDK Log] AppDelegate applicationWillResignActive  ---Become inactive---");
    #endif
    
    [self endSession];
}

#pragma mark - Session

// Start session
- (void)startSession {
    if (_lastStartSessionDate) {
        NSTimeInterval lastSatrtInterval = [[NSDate date] timeIntervalSinceDate:_lastStartSessionDate];
        if (lastSatrtInterval < START_SESSION_MIN_INTERVAL) {
            return;
        }
    }
    
    _sessionId = [XhanceMd5Utils MD5OfString:[[NSUUID UUID] UUIDString]];
    XhanceSessionModel *model = [[XhanceSessionModel alloc] initWithSessionId:_sessionId
                                                                         type:XhanceSessionModelTypeStart];
    [self sendSession:model];
    
    _lastStartSessionDate = [NSDate date];
    
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer timerWithTimeInterval:TIMER_SESSION_INTERVAL
                                     target:self
                                   selector:@selector(timerSession)
                                   userInfo:nil
                                    repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

// End session
- (void)endSession {
    if (_lastEndSessionDate) {
        NSTimeInterval lastSatrtInterval = [[NSDate date] timeIntervalSinceDate:_lastEndSessionDate];
        if (lastSatrtInterval < END_SESSION_MIN_INTERVAL) {
            return;
        }
    }
    
    if (_sessionId == nil || [_sessionId isEqualToString:@""]) {
        _sessionId = [XhanceMd5Utils MD5OfString:[[NSUUID UUID] UUIDString]];
    }
    XhanceSessionModel *model = [[XhanceSessionModel alloc] initWithSessionId:_sessionId
                                                                         type:XhanceSessionModelTypeEnd];
    [self sendSession:model];
    
    _lastEndSessionDate = [NSDate date];
    
    _sessionId = nil;
    
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
}

// Timer session
- (void)timerSession {
    if (_sessionId == nil || [_sessionId isEqualToString:@""]) {
        _sessionId = [XhanceMd5Utils MD5OfString:[[NSUUID UUID] UUIDString]];
    }
    XhanceSessionModel *model = [[XhanceSessionModel alloc] initWithSessionId:_sessionId
                                                                         type:XhanceSessionModelTypeTimer];
    [self sendSession:model];
    
    _timer = [NSTimer timerWithTimeInterval:TIMER_SESSION_INTERVAL
                                     target:self
                                   selector:@selector(timerSession)
                                   userInfo:nil
                                    repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

#pragma mark - CacheSession

- (void)cacheSession:(XhanceSessionModel *)sessionModel {
    [[XhanceSessionFileCache shareInstance] writeAdvertiserSession:sessionModel];
    [[XhanceSessionFileCache shareInstance] writeAdRealmSession:sessionModel];
}

#pragma mark - sendSession

- (void)sendSession:(XhanceSessionModel *)sessionModel {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self cacheSession:sessionModel];
        [self sendAdvertiserSession:sessionModel];
        [self sendAdRealmSession:sessionModel];
    });
    
    #ifdef UPLTVXhanceSDKDEBUG
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPLTVXhanceSDKDEBUGSENDSESSION"
                                                        object:sessionModel];
    #endif
}

- (void)sendAdvertiserSession:(XhanceSessionModel *)sessionModel {
    [XhanceSessionSend sendAdvertiserSession:sessionModel];
}

- (void)sendAdRealmSession:(XhanceSessionModel *)sessionModel {
    [XhanceSessionSend sendAdRealmSession:sessionModel];
}

#pragma mark - checkDefeatedSessionAndSend

- (void)checkDefeatedSessionAndSend {
    NSArray <XhanceSessionModel *> *defeatedAdvertiserSessions = [[XhanceSessionFileCache shareInstance] getAdvertiserSessions];
    for (int i = 0; i < defeatedAdvertiserSessions.count; i++) {
        XhanceSessionModel *sessionModel = [defeatedAdvertiserSessions objectAtIndex:i];
        [self sendAdvertiserSession:sessionModel];
    }
    
    NSArray <XhanceSessionModel *> *defeatedAdRealmSessions = [[XhanceSessionFileCache shareInstance] getAdRealmSessions];
    for (int i = 0; i < defeatedAdRealmSessions.count; i++) {
        XhanceSessionModel *sessionModel = [defeatedAdRealmSessions objectAtIndex:i];
        [self sendAdRealmSession:sessionModel];
    }
}

- (void)checkDefeatedSessionAndSendWithChildThread {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self checkDefeatedSessionAndSend];
    });
}

#pragma mark - SessionId

- (NSString *)getCurrentSessionId {
    if (_sessionId == nil) {
        return @"";
    }
    return _sessionId;
}

@end
