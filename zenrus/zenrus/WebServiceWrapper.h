//
//  WebServiceWrapper.h
//  zenrus
//
//  Created by Dennis Burdin on 21.01.17.
//  Copyright © 2017 Dennis Burdin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebServiceWrapper : NSObject

- (instancetype)initWithURLString:(NSString*)url;
- (void)test;

@end
