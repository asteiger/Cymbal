#import "PreferencesController.h"

static NSString *const kRanBeforeDefaultsKey = @"DefaultsRanBefore";
static NSString *const kBrodcastEnabledDefaultsKey = @"DefaultsBroadcastEnabled";
static NSString *const kAutoconnectEnabledDefaultsKey = @"DefaultsAutoconnectEnabled";
static NSString *const kShowDesktopNotificationDefaultsKey = @"DefaultsShowDesktopNotifications";

@implementation PreferencesController

static PreferencesController *sharedInstance;
+ (PreferencesController*)sharedInstance {
    if (nil == sharedInstance) {
        sharedInstance = [[PreferencesController alloc] init];
    }
    
    return sharedInstance;
}

- (id)init {
    if ((self = [super init])) {
        BOOL firstRun = ![[NSUserDefaults standardUserDefaults] boolForKey:kRanBeforeDefaultsKey];
        
        if (firstRun) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kRanBeforeDefaultsKey];
            
            self.allowBroadcasting = YES;
            self.allowAutoconnect = YES;
        } 
    }
    
    return self;
}

- (BOOL)allowBroadcasting {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kBrodcastEnabledDefaultsKey];
}

- (void)setAllowBroadcasting:(BOOL)allowBroadcasting {
    [[NSUserDefaults standardUserDefaults] setBool:allowBroadcasting forKey:kBrodcastEnabledDefaultsKey];
}

- (BOOL)allowAutoconnect {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kAutoconnectEnabledDefaultsKey];
}

- (void)setAllowAutoconnect:(BOOL)allowAutoconnect {
    [[NSUserDefaults standardUserDefaults] setBool:allowAutoconnect forKey:kAutoconnectEnabledDefaultsKey];
}

- (BOOL)showDesktopNotification {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kShowDesktopNotificationDefaultsKey];
}

- (void)setShowDesktopNotification:(BOOL)showDesktopNotification {
    [[NSUserDefaults standardUserDefaults] setBool:showDesktopNotification forKey:kShowDesktopNotificationDefaultsKey];
}

- (void)dealloc {
    [sharedInstance release];
    sharedInstance = nil;
    
    [super dealloc];
}

@end
