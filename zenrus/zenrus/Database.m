#import "Database.h"
#import "DataManager.h"

@implementation Database


#pragma mark - Object lifecirle

+ (Database *)sharedInstance {
    @synchronized (self) {
        static Database *instance = nil;
        if (!instance) {
            instance = [[Database alloc] init];
        }
        return instance;
    }
}

- (id) init {
    self = [super init];
    if (self) {
        self.databaseName = @"valutes";
        self.demoDatabaseName = @"demoValutes";
    }
    return self;
}


#pragma mark - Database reset/switch function

- (void)resetDatabase
{
    __block NSError *error;
    // retrieve the store URL
    __block NSURL * storeURL = [[self.managedObjectContext persistentStoreCoordinator] URLForPersistentStore:[[[self.managedObjectContext persistentStoreCoordinator] persistentStores] lastObject]];
    // lock the current context
    [self.managedObjectContext performBlockAndWait:^{
        [self.managedObjectContext reset];//to drop pending changes
        //delete the store from the current managedObjectContext
        if ([[self.managedObjectContext persistentStoreCoordinator] removePersistentStore:[[[self.managedObjectContext persistentStoreCoordinator] persistentStores] lastObject] error:&error]) {
            // remove the file containing the data
            [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
            //recreate the store like in the  appDelegate method
            [[self.managedObjectContext persistentStoreCoordinator] addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];//recreates the persistent store
        }
    }];
    
    self.managedObjectContext = nil;
    self.persistentStoreCoordinatorWork = nil;
    self.managedObjectModel = nil;
}

- (void)prepareForSwitchStore
{
    self.managedObjectContext = nil;
    self.persistentStoreCoordinatorWork = nil;
    self.managedObjectModel = nil;
}

@end
