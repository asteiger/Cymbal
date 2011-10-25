
@interface PreferencesController : NSObject {

}

@property (nonatomic) BOOL allowBroadcasting;
@property (nonatomic) BOOL showDesktopNotification;
@property (nonatomic) BOOL startAtLogin;

+ (PreferencesController*)sharedInstance;
- (NSURL *)appURL;

@end
