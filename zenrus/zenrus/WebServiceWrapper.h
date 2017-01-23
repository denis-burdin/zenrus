//
//  WebServiceWrapper.h
//  zenrus
//
//  Created by Dennis Burdin on 21.01.17.
//  Copyright © 2017 Dennis Burdin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CurrencyIndexDate = 0,
    CurrencyIndexUSDollarValue,
    CurrencyIndexEuroValue
} CurrencyIndex;

@interface WebServiceWrapper : NSObject

- (instancetype)initWithURLString:(NSString*)url;
- (void)run:(void (^)(NSArray* result))completion;

@end
