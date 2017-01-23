#import "BaseEntityManager.h"

typedef enum
{
    kRatesDate = 0,
    kRatesValue,
    kRatesValuteID
} RateManagerListIndexes;

@interface RatesManager : BaseEntityManager

-(NSArray *)listRates;

@end

