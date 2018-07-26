//
//  XhanceParameter.m
//  XhanceSDK
//
//  Created by steve on 2018/5/17.
//  Copyright © 2018 Adrealm. All rights reserved.
//

#import "XhanceSessionParameter.h"

@interface XhanceSessionParameter ()
{
    XhanceSessionModel *_session;
}
@end

@implementation XhanceSessionParameter

- (instancetype)initWithSession:(XhanceSessionModel *)session {
    NSString *timeStamp = [XhanceUtil getDateTimeStampWithDate:session.clientTime];
    self = [super initWithTimeStamp:timeStamp];
    if (self) {
        _session = session;
        [self createDataForAdvertiser];
        [self createDataForAdRealm];
    }
    return self;
}

- (void)createDataForAdvertiser {
    
    /*
     @param s_id Abbreviation for session_id
     @param cat Short name of category, indicating the classification of events, session cate=session
     @param e_id The short name of event_id indicates the name of the event.
            The e_id enumeration type of the session consists of three types: s_start, s_end, s_going.
     @param val Abbreviation of value, indicating the value of the event, the session does not need to pass, it is empty
     */
    NSString *s_id = _session.sessionID;
    NSString *cat = @"session";
    NSString *e_id = @"";
    if (_session.dataType == XhanceSessionModelTypeStart) {
        e_id = @"s_start";
    } else if (_session.dataType == XhanceSessionModelTypeTimer) {
        e_id = @"s_going";
    } else if (_session.dataType == XhanceSessionModelTypeEnd) {
        e_id = @"s_end";
    }
    NSString *val = @"";
    
    // set session parameters
    [self.dataForAdvertiser setCheckObject:s_id forKey:@"s_id"];
    [self.dataForAdvertiser setCheckObject:cat forKey:@"cat"];
    [self.dataForAdvertiser setCheckObject:e_id forKey:@"e_id"];
    [self.dataForAdvertiser setCheckObject:val forKey:@"val"];
    
    [super createDataForAdvertiser];
}

- (void)createDataForAdRealm {
    [super createDataForAdRealm];
}

@end
