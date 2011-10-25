#import "PreferencesController.h"
#import "LoginItem.h"

static NSString *const kRanBeforeDefaultsKey = @"DefaultsRanBefore";
static NSString *const kBrodcastEnabledDefaultsKey = @"DefaultsBroadcastEnabled";
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
            self.showDesktopNotification = YES;
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

- (BOOL)showDesktopNotification {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kShowDesktopNotificationDefaultsKey];
}

- (void)setShowDesktopNotification:(BOOL)showDesktopNotification {
    [[NSUserDefaults standardUserDefaults] setBool:showDesktopNotification forKey:kShowDesktopNotificationDefaultsKey];
}

- (BOOL)startAtLogin
{
    return [LoginItem willStartAtLogin:[self appURL]];
}

- (void)setStartAtLogin:(BOOL)enabled
{
    [self willChangeValueForKey:@"startAtLogin"];
    [LoginItem setStartAtLogin:[self appURL] enabled:enabled];
    [self didChangeValueForKey:@"startAtLogin"];
}

- (NSURL *)appURL
{
    return [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
}

- (void)dealloc {
    [sharedInstance release];
    sharedInstance = nil;
    
    [super dealloc];
}

@end
