#import "CoreDataDatabase.h"
#import "DataManager.h"

@implementation CoreDataDatabase

#pragma mark - Core data working

- (NSManagedObjectContext *) managedObjectContext
{
    static NSManagedObjectContext *context = nil;
    
    @autoreleasepool
    {
        context = [[NSManagedObjectContext alloc] init];
        
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        [context setPersistentStoreCoordinator:coordinator];
        
        NSString *STORE_TYPE = NSSQLiteStoreType;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
        
        NSString *storePath = [basePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db", @"valutes"]];
        
        // at initial state we are copying our demo database to see any tourists data
        if (! [[NSFileManager defaultManager] fileExistsAtPath:storePath])
        {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"valutes" ofType:@"db"];
            
            if (defaultStorePath)
            {
                [fileManager copyItemAtPath:defaultStorePath
                                     toPath:storePath
                                      error:NULL];
            }
        }
        
        NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
        NSError *error;
        NSDictionary *storeOptions = @{ NSSQLitePragmasOption : @{@"journal_mode" : @"DELETE"} };
        
        NSPersistentStore *newStore = [coordinator addPersistentStoreWithType:STORE_TYPE configuration:nil URL:storeUrl options:storeOptions error:&error];
        
        if (newStore == nil)
        {
            NSLog(@"Store Configuration Failure %@", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
        }
    }
    
    return context;
}

- (NSManagedObjectModel *)managedObjectModel
{
    static NSManagedObjectModel *model = nil;
    if (model != nil) {
        return model;
    }

    model = [NSManagedObjectModel mergedModelFromBundles:nil];
    return model;
}

- (void) save
{
    @synchronized (self.managedObjectContext)
    {
        [self.managedObjectContext save:nil];
    }
}

@end
