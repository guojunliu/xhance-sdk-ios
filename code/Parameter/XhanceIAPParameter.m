//
//  XhanceIAPParameter.m
//  XhanceSDK
//
//  Created by steve on 2018/5/29.
//  Copyright © 2018 Adrealm. All rights reserved.
//

#import "XhanceIAPParameter.h"
#import "XhanceSessionManager.h"
#import "XhanceUtil.h"

@implementation XhanceIAPParameter
@synthesize productPrice = _productPrice;
@synthesize productCurrencyCode = _productCurrencyCode;
@synthesize productIdentifier = _productIdentifier;
@synthesize productCategory = _productCategory;
@synthesize receiptDataString = _receiptDataString;
@synthesize pubkey = _pubkey;
@synthesize params = _params;

- (instancetype)initWithProductPrice:(NSNumber *)productPrice
                 productCurrencyCode:(NSString *)productCurrencyCode
                   productIdentifier:(NSString *)productIdentifier
                     productCategory:(NSString *)productCategory
                   receiptDataString:(NSString *)receiptDataString
                              pubkey:(NSString *)pubkey
                              params:(NSDictionary *)params
                          isThirdPay:(BOOL)isThirdPay {
    
    NSString *timeStamp = [XhanceUtil getDateTimeStamp];
    self = [super initWithTimeStamp:timeStamp];
    if (self) {
        self.productPrice = productPrice;
        self.productCurrencyCode = productCurrencyCode;
        self.productIdentifier = productIdentifier;
        self.productCategory = productCategory;
        self.receiptDataString = receiptDataString;
        self.pubkey = pubkey;
        self.params = params;
        
        if (isThirdPay) {
            [self createDataForAdvertiserWithThirdPay];
        }
        else {
            [self createDataForAdvertiserWithAppStore];
        }
        
        [self createDataForAdRealm];
    }
    return self;
}

- (void)createDataForAdvertiserWithAppStore {
    NSString *paramsStr = @"";
    if (_params) {
        paramsStr = [XhanceUtil dictionaryToJson:_params];
        if (paramsStr != nil && ![paramsStr isEqualToString:@""]) {
            NSString *str = [XhanceUtil URLEncodedString:paramsStr];
            paramsStr = str;
        }
    }
    
    /*
     @param cat Short name of category, indicating the classification of events, session cate=session
     @param revn Revenue in-app purchases, the unit is the amount, the type is long
     @param revn_curr Revenue_currency Abbreviation for the currency of the purchase of the purchase, three uppercase English characters
     @param pubkey If it is Android, pass the payment public key of gp, if it is ios, pass the shared key.
     @param sign If it is Android, the signature verification returned after gp payment, if it is ios, it will receive receipt
     @param params Json type, cp is set according to map
     */
    NSString *cat = @"revenue";
    NSNumber *revn = _productPrice;
    NSString *revn_curr = _productCurrencyCode;
    NSString *pubkey = _pubkey;
    NSString *sign = _receiptDataString;
    NSString *params = paramsStr;
    
    // set IAP parameters
    [self.dataForAdvertiser setCheckObject:cat forKey:@"cat"];
    [self.dataForAdvertiser setCheckObject:revn forKey:@"revn"];
    [self.dataForAdvertiser setCheckObject:revn_curr forKey:@"revn_curr"];
    [self.dataForAdvertiser setCheckObject:pubkey forKey:@"pubkey"];
    [self.dataForAdvertiser setCheckObject:sign forKey:@"sign"];
    [self.dataForAdvertiser setCheckObject:params forKey:@"params"];
    
    [super createDataForAdvertiser];
}

- (void)createDataForAdvertiserWithThirdPay {
    
    /*
     @param cat Short name of category, indicating the classification of events, revenue cate=revenue
     @param revn Revenue in-app purchases, the unit is the amount, the type is long
     @param revn_curr Revenue_currency Abbreviation for the currency of the purchase of the purchase, three uppercase English characters
     @param item_id The id mark of the goods purchased by the in-app purchase
     @param item_cat Classification of goods purchased by pay-per-use
     */
    NSString *cat = @"revenue";
    NSNumber *revn = _productPrice;
    NSString *revn_curr = _productCurrencyCode;
    NSString *item_id = _productIdentifier;
    NSString *item_cat = _productCategory;
    
    // set IAP parameters
    [self.dataForAdvertiser setCheckObject:cat forKey:@"cat"];
    [self.dataForAdvertiser setCheckObject:revn forKey:@"revn"];
    [self.dataForAdvertiser setCheckObject:revn_curr forKey:@"revn_curr"];
    [self.dataForAdvertiser setCheckObject:item_id forKey:@"item_id"];
    [self.dataForAdvertiser setCheckObject:item_cat forKey:@"item_cat"];
    
    [super createDataForAdvertiser];
}

- (void)createDataForAdRealm {
    [super createDataForAdRealm];
}

@end
