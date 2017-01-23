//
//  Rates+CoreDataProperties.h
//  zenrus
//
//  Created by Dennis Burdin on 23.01.17.
//  Copyright © 2017 Dennis Burdin. All rights reserved.
//

#import "Rates+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Rates (CoreDataProperties)

+ (NSFetchRequest<Rates *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *date;
@property (nullable, nonatomic, copy) NSString *value;
@property (nullable, nonatomic, copy) NSString *valute_id;

@end

NS_ASSUME_NONNULL_END
