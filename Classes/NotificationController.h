#import "MCSongData.h"
#import "MAAttachedWindow.h"
#import "NotificationViewController.h"

@interface NotificationController : NSObject  {
    NotificationViewController *nvc;
    MAAttachedWindow *notificationWindow;
    NSTimer *timer;
}

+ (NotificationController*)sharedInstance;
- (void)postNotificationWithSong:(MCSongData*)songData;
- (void)postNotificationWithTitle:(NSString*)title Description:(NSString*)description NotificationName:(NSString*)notificationName;
- (void)postBroadcastEnabledNotificationWithState:(int)state;
- (void)postConnectedToBroadcasterWithName:(NSString*)name;
- (void)timerFire:(NSTimer*)timer;

@end
