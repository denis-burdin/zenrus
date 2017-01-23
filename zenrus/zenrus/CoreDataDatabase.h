#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataDatabase : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinatorWork;
@property (nonatomic, strong) NSString *databaseName;
@property (nonatomic, strong) NSString *demoDatabaseName;

- (void) save;

@end
