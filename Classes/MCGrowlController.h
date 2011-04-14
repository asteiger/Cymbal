#import "MCSongData.h"
#import "Growl.framework/Headers/GrowlApplicationBridge.h"


@interface MCGrowlController : NSObject <GrowlApplicationBridgeDelegate> {

}

+ (void)postNotificationWithSong:(MCSongData*)songData;
+ (void)postNotificationWithTitle:(NSString*)title Description:(NSString*)description NotificationName:(NSString*)notificationName;
+ (void)postBroadcastEnabledNotificationWithState:(int)state;
+ (void)postConnectedToBroadcasterWithName:(NSString*)name;

@end
