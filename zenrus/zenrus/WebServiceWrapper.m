//
//  WebServiceWrapper.m
//  zenrus
//
//  Created by Dennis Burdin on 21.01.17.
//  Copyright © 2017 Dennis Burdin. All rights reserved.
//

#import "WebServiceWrapper.h"
#import <XMLDictionary/XMLDictionary.h>
#import <AFNetworking/AFNetworking.h>

static NSString *const kUSDollarID = @"R01235";
static NSString *const kEuroID = @"R01239";

// NSUserDefaults
static NSString *const kUserDefaultsDateKey = @"LastRefreshedDateKey";
static NSString *const kUserDefaultsValueUSKey = @"LastRefreshedUSValueKey";
static NSString *const kUserDefaultsValueEuroKey = @"LastRefreshedEuroValueKey";

@interface WebServiceWrapper ()
{
    NSURL *_urlService;
}

@end

@implementation WebServiceWrapper

- (instancetype)initWithURLString:(NSString*)url {
    self = [super init];
    
    if (self) {
        _urlService = [NSURL URLWithString:url];
    }

    return self;
}

- (void)downloadXML:(void (^)(NSString *xmlString, NSError *error))handler {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/xml"];
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:[NSURLRequest requestWithURL:_urlService] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            handler(nil, error);
        } else {
            NSString *fetchedXML = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSWindowsCP1251StringEncoding];
            handler(fetchedXML, nil);
        }
    }];
    [task resume];
}

- (NSArray*)replicateDataToDB:(NSString*)date andValutes:(NSDictionary*)valutes {
    // TODO: investigate why [context executeFetchRequest] returns empty array
    //NSArray *ratesData = [RATES_MANAGER listRates];
    NSString *USDollarValue = [valutes objectForKey:kUSDollarID];
    NSString *EuroValue = [valutes objectForKey:kEuroID];
    
    [self saveToDB:date dollar:USDollarValue euro:EuroValue]; // TODO: USE CORE DATA INSTEAD OF THAT!
    
    return @[date, USDollarValue, EuroValue]; // CurrencyIndex
}

- (void)saveToDB:date dollar:USDollarValue euro:EuroValue {
    // in fact this function is redundant because of Safari saves xml responce internally in web history and returns it when internet is not available
    [USER_DEFAULTS setObject:date forKey:kUserDefaultsDateKey];
    [USER_DEFAULTS setObject:USDollarValue forKey:kUserDefaultsValueUSKey];
    [USER_DEFAULTS setObject:EuroValue forKey:kUserDefaultsValueEuroKey];
    [USER_DEFAULTS synchronize];
}

- (NSArray*)readFromDB {
    NSString* date = [USER_DEFAULTS stringForKey:kUserDefaultsDateKey];
    NSString* valueUS = [USER_DEFAULTS stringForKey:kUserDefaultsValueUSKey];
    NSString* valueEuro = [USER_DEFAULTS stringForKey:kUserDefaultsValueEuroKey];
    return @[date, valueUS, valueEuro];
}

- (NSDictionary*)groomValutes:(NSArray*)valutes {
    NSMutableDictionary<NSString*, NSString*> *dict = [NSMutableDictionary new];
    for (NSDictionary *valute in valutes) {
        [dict setValue:valute[@"Value"] forKey:valute[@"_ID"]];
    }

    return dict;
}

- (void)run:(void (^)(NSArray* result))completion {
    [self downloadXML:^(NSString *xmlString, NSError *error) {
        NSArray* result = nil;
        
        if (xmlString.length) {
            NSDictionary *rates = [[XMLDictionaryParser sharedInstance] dictionaryWithString:xmlString];
            NSString* date = [rates objectForKey:@"_Date"];
            NSDictionary* valutes = [self groomValutes:[rates objectForKey:@"Valute"]];
            result = [self replicateDataToDB:date andValutes:valutes]; // TODO: investigate why deep link doesn't work
        } else {
            // error, try to read previously saved values
            result = [self readFromDB];
        }
        
        completion(result);
    }];
}

@end
