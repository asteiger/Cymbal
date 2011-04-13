
@protocol GrowlNotifier <NSObject>

+ (void)postNotificationWithSong:(MCSongData*)songData;
+ (void)postNotificationWithTitle:(NSString*)title Description:(NSString*)description NotificationName:(NSString*)notificationName;
+ (void)postBroadcastEnabledNotificationWithState:(int)state;
+ (void)postConnectedToBroadcasterWithName:(NSString*)name;

@end
