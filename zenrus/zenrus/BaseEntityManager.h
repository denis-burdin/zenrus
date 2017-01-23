#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface BaseEntityManager : NSObject

@property (nonatomic, readonly) NSString *entityName;
@property (nonatomic, readonly) NSString *primaryKey;
@property (nonatomic, readonly) NSManagedObjectContext *context;

- (id) createNew;
- (id) retrieveWithId:(int)entityId;
- (id) entityWithId:(int)entityId;

- (id) retrieveEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate;

- (NSArray *)retrieveEntitesWithPredicate:(NSPredicate *)predicate;

- (NSArray *) retrieveEntites:(NSString *)entityName withPredicate:(NSPredicate *)predicate;
- (NSArray *) retrieveEntites:(NSString *)entityName withPredicate:(NSPredicate *)predicate withSortDescriptors:(NSArray *)sortDescriptors;

- (NSArray *) findParams:(NSString *)paramName ofEntity:(NSString *)entityName withResultType:(NSAttributeType)type withPredicate:(NSPredicate *)predicate;

- (int) entityCount:(NSString *)entityName forPredicate:(NSPredicate *)predicate;
- (int)nextAvailble:(NSString *)idKey forEntityName:(NSString *)entityName;

- (void) deleteEntity:(NSManagedObject *)entity;
- (void) deleteEntities:(NSString *)entityName withPredicate:(NSPredicate *)predicate;
- (void) deleteEntities:(NSArray *)entities;

@end