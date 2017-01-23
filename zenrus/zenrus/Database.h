#import <Foundation/Foundation.h>
#import "CoreDataDatabase.h"

@interface Database : CoreDataDatabase

+ (Database *)sharedInstance;

- (void)resetDatabase;
- (void)prepareForSwitchStore;

@end
