#ifndef Constants_h
#define Constants_h

#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]
#define NOTIFICATION_CENTER [NSNotificationCenter defaultCenter]
#define DATA_MANAGER [DataManager sharedInstance]
#define SETTINGS_MANAGER [DataManager sharedInstance].settingsManager
#define RATES_MANAGER [DataManager sharedInstance].ratesManager

#endif
