#import "DataManager.h"
#import "Database.h"

@interface DataManager()

@end

@implementation DataManager

static DataManager *instance = nil;

+ (DataManager *)sharedInstance {
    @synchronized (self) {
        if (!instance) {
            instance = [DataManager new];
        }
        return instance;
    }
}

- (id)init
{
	self = [super init];
	if (self)
    {
        self.ratesManager = [[RatesManager alloc] init];

	}
	return self;
}


- (NSManagedObjectContext *)context
{
    return [Database sharedInstance].managedObjectContext;
}

@end
