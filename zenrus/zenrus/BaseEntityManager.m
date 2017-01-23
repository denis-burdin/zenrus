#import "BaseEntityManager.h"
#import "Database.h"
#import "DataManager.h"

@implementation BaseEntityManager

- (NSString *)entityName {
    return nil;
}

- (NSString *)primaryKey {
    return nil;
}

- (NSManagedObjectContext *)context {
    return [Database sharedInstance].managedObjectContext;
}

#pragma mark - Single entity working

- (id) createNew
{
    @synchronized (self.context) {
        return [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:self.context];
    }
}

- (id)retrieveWithId:(int)entityId
{
    return [self retrieveEntity:self.entityName withPredicate:[NSPredicate predicateWithFormat:@"%K == %d", self.primaryKey, entityId]];
}

- (id)entityWithId:(int)entityId
{
    NSManagedObject *entity = [self retrieveWithId:entityId];
    if (!entity) {
        entity = [self createNew];
        [entity setValue:[NSNumber numberWithInt:entityId] forKey:self.primaryKey];
    }
    return entity;
}

- (id) retrieveEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate
{
    NSArray *entities = [self retrieveEntites:entityName withPredicate:predicate];
    if (entities.count) {
        return [entities objectAtIndex:0];
    }
    return nil;
}


#pragma mark - Multiple entity working

- (NSArray *)retrieveEntitesWithPredicate:(NSPredicate *)predicate
{
    return [self retrieveEntites:self.entityName withPredicate:predicate];
}

- (NSArray *) retrieveEntites:(NSString *)entityName withPredicate:(NSPredicate *)predicate
{
    return [self retrieveEntites:entityName withPredicate:predicate withSortDescriptors:nil];
}

- (NSArray *) retrieveEntites:(NSString *)entityName withPredicate:(NSPredicate *)predicate withSortDescriptors:(NSArray *)sortDescriptors
{
    return [self retrieveEntites:entityName withPredicate:predicate withSortDescriptors:sortDescriptors withLimit:0];
}

- (NSArray *) retrieveEntites:(NSString *)entityName withPredicate:(NSPredicate *)predicate withSortDescriptors:(NSArray *)sortDescriptors withLimit:(int)limit
{
    @synchronized (self.context) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.context];
        [request setEntity:entity];
        
        if (predicate)
        {
            [request setPredicate:predicate];
        }
        
        if (sortDescriptors)
        {
            [request setSortDescriptors:sortDescriptors];
        }
        
        if (limit)
        {
            [request setFetchLimit:limit];
        }
        
        NSError *error = nil;
        NSArray *entities =  [self.context executeFetchRequest:request error:&error];
        
        if (error)
        {
            NSLog(@"\nCore Data Error: %@\n\n", error.description);
        }
        
        return entities;
    }
}

- (NSArray *) findParams:(NSString *)paramName ofEntity:(NSString *)entityName withResultType:(NSAttributeType)type withPredicate:(NSPredicate *)predicate
{
    @synchronized (self.context) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.context];
        [request setEntity:entity];
        
        
        [request setResultType:NSDictionaryResultType];
        NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:paramName];
        
        // Create an expression description using the minExpression and returning a date.
        NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
        
        // The name is the key that will be used in the dictionary for the return value.
        [expressionDescription setName:paramName];
        [expressionDescription setExpression:keyPathExpression];
        [expressionDescription setExpressionResultType:type];
        
        // Set the request's properties to fetch just the property represented by the expressions.
        [request setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
        
        if (predicate) {
            request.predicate = predicate;
        }
        
        // Execute the fetch.
        NSError *error = nil;
        NSArray *infoArray = [self.context executeFetchRequest:request error:&error];
        
        if (error)
        {
            NSLog(@"\nCore Data Error: %@\n\n", error.description);
        }

        NSMutableArray *filteredInfoArray = [NSMutableArray new];
        for (NSDictionary *info in infoArray) {
            id value = [info objectForKey:paramName];
            [filteredInfoArray addObject:value];
        }
        return filteredInfoArray;
    }
}

- (int)nextAvailble:(NSString *)idKey forEntityName:(NSString *)entityName {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *moc = self.context;
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:moc];
    
    [request setEntity:entity];
    // [request setFetchLimit:1];
    
    NSArray *propertiesArray = [[NSArray alloc] initWithObjects:idKey, nil];
    [request setPropertiesToFetch:propertiesArray];
    propertiesArray = nil;
    
    NSSortDescriptor *indexSort = [[NSSortDescriptor alloc] initWithKey:idKey ascending:YES];
    NSArray *array = [[NSArray alloc] initWithObjects:indexSort, nil];
    [request setSortDescriptors:array];
    array = nil;
    indexSort = nil;
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    // NSSLog(@"Autoincrement fetch results: %@", results);
    NSManagedObject *maxIndexedObject = [results lastObject];
    request = nil;
    if (error)
    {
        NSLog(@"\nError fetching index: %@\n%@\n\n", [error localizedDescription], [error userInfo]);
    }
    //NSAssert3(error == nil, @"Error fetching index: %@\n%@", [error localizedDescription], [error userInfo]);
    
    NSInteger myIndex = 1;
    if (maxIndexedObject) {
        myIndex = [[maxIndexedObject valueForKey:idKey] integerValue] + 1;
    }
    
    return (int)myIndex;
}


#pragma mark - Entity count

- (int) entityCount:(NSString *)entityName forPredicate:(NSPredicate *)predicate
{
    @synchronized (self.context) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
       
        NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.context];
        [request setEntity:entity];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        int count = (int)[self.context countForFetchRequest:request error:&error];
        
        if (error)
        {
            NSLog(@"\nCore Data Error: %@\n\n", error.description);
        }
        return count;
    }
}


#pragma mark - Deleting

- (void) deleteEntity:(NSManagedObject *)entity
{
    @synchronized (self.context) {
        [self.context deleteObject:entity];
    }
    [[Database sharedInstance] save];
}

- (void) deleteEntities:(NSString *)entityName withPredicate:(NSPredicate *)predicate
{
    NSArray *entities = [self retrieveEntites:entityName withPredicate:predicate];
    [self deleteEntities:entities];
}

- (void) deleteEntities:(NSArray *)entities
{
    @synchronized (self.context) {
        for (NSManagedObject *entity in entities) {
            [self.context deleteObject:entity];
        }
    }
    [[Database sharedInstance] save];
}

@end
