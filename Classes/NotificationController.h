#import "MCSongData.h"
#import "MAAttachedWindow.h"
#import "NotificationViewController.h"
#import <Growl/GrowlApplicationBridge.h>

@interface NotificationController : NSObject <GrowlApplicationBridgeDelegate> {
    NotificationViewController *nvc;
    MAAttachedWindow *notificationWindow;
    NSTimer *timer;
    
    NSRect originalViewFrame;
    NSMutableArray *notifications;
}

+ (NotificationController*)sharedInstance;
- (void)postNotificationWithSong:(MCSongData*)songData;
- (void)postBroadcastStartedNotification;
- (void)postBroadcastStoppedNotification;
- (void)postConnectedToBroadcasterWithName:(NSString*)name;
- (void)postDisconnectedFromBroadcasterWithName:(NSString*)name;
- (void)postListenerConnectedWithName:(NSString*)name;
- (void)postListenerDisconnectedWithName:(NSString*)name;
- (void)postNextNotification;

@end
