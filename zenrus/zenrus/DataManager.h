#import <UIKit/UIKit.h>

#import "RatesManager.h"

@interface DataManager : NSObject<UIAlertViewDelegate>

@property (nonatomic, strong) RatesManager *ratesManager;

+ (DataManager *) sharedInstance;

@end
