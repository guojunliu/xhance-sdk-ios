//
//  XhanceIAPParameter.h
//  XhanceSDK
//
//  Created by steve on 2018/5/29.
//  Copyright © 2018 Adrealm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XhanceBaseParameter.h"

@interface XhanceIAPParameter : XhanceBaseParameter

@property (nonatomic) NSNumber *productPrice;
@property (nonatomic,copy) NSString *productCurrencyCode;
@property (nonatomic,copy) NSString *productIdentifier;
@property (nonatomic,copy) NSString *productCategory;
@property (nonatomic,copy) NSString *receiptDataString;
@property (nonatomic,copy) NSString *pubkey;
@property (nonatomic) NSDictionary *params;

- (instancetype)initWithProductPrice:(NSNumber *)productPrice
                 productCurrencyCode:(NSString *)productCurrencyCode
                   productIdentifier:(NSString *)productIdentifier
                     productCategory:(NSString *)productCategory
                   receiptDataString:(NSString *)receiptDataString
                              pubkey:(NSString *)pubkey
                              params:(NSDictionary *)params
                          isThirdPay:(BOOL)isThirdPay;

@end
