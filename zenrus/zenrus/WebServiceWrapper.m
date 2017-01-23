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

- (void)replicateDataToDB:(NSString*)date andValutes:(NSDictionary*)valutes {
    // TODO: investigate why [context executeFetchRequest] returns empty array
    //NSArray *ratesData = [RATES_MANAGER listRates];
    NSString *USDollarValue = [valutes objectForKey:kUSDollarID];
    NSString *EuroValue = [valutes objectForKey:kEuroID];
    NSLog(@"");
}

- (NSDictionary*)groomValutes:(NSArray*)valutes {
    NSMutableDictionary<NSString*, NSString*> *dict = [NSMutableDictionary new];
    for (NSDictionary *valute in valutes) {
        [dict setValue:valute[@"Value"] forKey:valute[@"_ID"]];
    }
    
    return dict;
}

- (void)test {
    [self downloadXML:^(NSString *xmlString, NSError *error) {
        if (xmlString.length) {
            NSDictionary *rates = [[XMLDictionaryParser sharedInstance] dictionaryWithString:xmlString];
            NSString* date = [rates objectForKey:@"_Date"];
            NSDictionary* valutes = [self groomValutes:[rates objectForKey:@"Valute"]];
            [self replicateDataToDB:date andValutes:valutes]; // TODO: investigate why deep link doesn't work
        }
    }];
}

@end
