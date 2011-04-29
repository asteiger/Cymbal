#import "MCSongData.h"
#import "MAAttachedWindow.h"
#import "NotificationViewController.h"

@interface NotificationController : NSObject  {
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
- (void)postNextNotification;
- (void)timerFire:(NSTimer*)timer;

@end
