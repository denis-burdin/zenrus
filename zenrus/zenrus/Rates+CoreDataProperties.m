//
//  Rates+CoreDataProperties.m
//  zenrus
//
//  Created by Dennis Burdin on 23.01.17.
//  Copyright © 2017 Dennis Burdin. All rights reserved.
//

#import "Rates+CoreDataProperties.h"

@implementation Rates (CoreDataProperties)

+ (NSFetchRequest<Rates *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Rates"];
}

@dynamic date;
@dynamic value;
@dynamic valute_id;

@end
