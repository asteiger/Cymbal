#import "MCSongData.h"
#import "MAAttachedWindow.h"



@interface NotificationController : NSObject  {
    MAAttachedWindow *notificationWindow;
    NSTimer *timer;
}

@property (nonatomic, retain) MAAttachedWindow *notificationWindow;

+ (NotificationController*)sharedInstance;
- (void)postNotificationWithSong:(MCSongData*)songData;
- (void)postNotificationWithTitle:(NSString*)title Description:(NSString*)description NotificationName:(NSString*)notificationName;
- (void)postBroadcastEnabledNotificationWithState:(int)state;
- (void)postConnectedToBroadcasterWithName:(NSString*)name;
- (void)timerFire:(NSTimer*)timer;

@end
