
@interface PreferencesController : NSObject {

}

@property (nonatomic) BOOL allowAutoconnect;
@property (nonatomic) BOOL allowBroadcasting;
@property (nonatomic) BOOL showDesktopNotification;

+ (PreferencesController*)sharedInstance;

@end
