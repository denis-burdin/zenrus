#import "RatesManager.h"
#import "Rates+CoreDataProperties.h"
#import "DataManager.h"
#import "Database.h"

@implementation RatesManager

- (id)init
{
    self = [super init];
    
    if (self)
    {
    }
    
    return self;
}

- (NSString *)entityName
{
    return @"Rates";
}

- (NSArray *)listRates
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    NSArray *items = [self retrieveEntites:self.entityName withPredicate:nil];
    
    for (Rates *item in items)
    {
        NSArray *arr = @[item.date, item.value, item.valute_id];
        [list addObject:arr];
    }
    
    return list;
}

@end
