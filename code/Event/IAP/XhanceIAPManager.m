//
//  XhanceIAPManager.m
//  XhanceSDK
//
//  Created by steve on 2018/5/30.
//  Copyright © 2018 Adrealm. All rights reserved.
//

#import "XhanceIAPManager.h"
#import "XhanceHttpManager.h"
#import "XhanceIAPSend.h"
#import "XhanceIAPParameter.h"

@interface XhanceIAPManager ()

@end

@implementation XhanceIAPManager

+ (void)appStoreWithProductPrice:(NSNumber *)productPrice
             productCurrencyCode:(NSString *)productCurrencyCode
               receiptDataString:(NSString *)receiptDataString
                          pubkey:(NSString *)pubkey
                          params:(NSDictionary *)params {
    XhanceIAPParameter *parameter = [[XhanceIAPParameter alloc] initWithProductPrice:productPrice
                                                           productCurrencyCode:productCurrencyCode
                                                             productIdentifier:@""
                                                               productCategory:@""
                                                             receiptDataString:receiptDataString
                                                                        pubkey:pubkey
                                                                        params:params
                                                                    isThirdPay:NO];
    [XhanceIAPSend sendAdvertiserIAP:parameter];
    [XhanceIAPSend sendAdRealmIAP:parameter];
}

+ (void)thirdPayWithProductPrice:(NSNumber *)productPrice
             productCurrencyCode:(NSString *)productCurrencyCode
               productIdentifier:(NSString *)productIdentifier
                 productCategory:(NSString *)productCategory {
    XhanceIAPParameter *parameter = [[XhanceIAPParameter alloc] initWithProductPrice:productPrice
                                                           productCurrencyCode:productCurrencyCode
                                                             productIdentifier:productIdentifier
                                                               productCategory:productCategory
                                                             receiptDataString:@""
                                                                        pubkey:@""
                                                                        params:nil
                                                                    isThirdPay:YES];
    [XhanceIAPSend sendAdvertiserIAP:parameter];
    [XhanceIAPSend sendAdRealmIAP:parameter];
}

@end
