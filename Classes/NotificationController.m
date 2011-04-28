#import "NotificationController.h"

@implementation NotificationController

static NotificationController *instance;
+ (NotificationController*)sharedInstance {
    if (instance) return instance;
    
    @synchronized(self) {
        if (!instance) {
            instance = [[self alloc] init];
        }
    }
    
    return instance;
}

- (id)init {
    if ((self = [super init])) {
        NSRect rect = [[NSScreen mainScreen] visibleFrame];
        NSPoint point = NSMakePoint(rect.size.width, rect.size.height - 20);
        
        nvc = [[NotificationViewController alloc] initWithNibName:@"NotificationViewController" bundle:nil];
        
        notificationWindow = [[MAAttachedWindow alloc] initWithView:nvc.view attachedToPoint:point onSide:MAPositionLeft atDistance:10];
        [notificationWindow setHasArrow:0];
        [notificationWindow setLevel:NSFloatingWindowLevel];
    }
    
    return self;
}

- (void)notificationWindowWithTitle:(NSString*)title Subject1:(NSString*)subject1 Subject2:(NSString*)subject2 {
    @synchronized(self) {
        [timer fire];
    
        nvc.titleLine = title;
        nvc.subjectLine1 = subject1;
        nvc.subjectLine2 = subject2;
        
        [notificationWindow setAlphaValue:0.0];
        [notificationWindow orderFront:self];
        
        [NSAnimationContext beginGrouping];
        [[NSAnimationContext currentContext] setDuration:0.4];	
        [[notificationWindow animator] setAlphaValue:1.0];
        [NSAnimationContext endGrouping];
        
        timer = [[NSTimer timerWithTimeInterval:3 target:self selector:@selector(timerFire:) userInfo:nil repeats:NO] retain];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
         
        NSLog(@"notify: %@ %@ %@", title, subject1, subject2);
    }
}

- (void)timerFire:(NSTimer*)aTimer {
    [notificationWindow orderOut:self];
    
    [timer invalidate];
    [timer release];
    timer = nil;
}

- (void)postNotificationWithSong:(MCSongData*)songData {
    NSLog(@"Posting song notification");
    
    [self notificationWindowWithTitle:songData.songTitle Subject1:songData.artist Subject2:songData.album];
}

- (void)postNotificationWithTitle:(NSString*)title Description:(NSString*)description NotificationName:(NSString*)notificationName {
	
}

- (void)postBroadcastEnabledNotificationWithState:(int)state {
	//NSString *stateMessage = state == NSOnState ? @"Broadcast Enabled" : @"Broadcast Disabled";
	
	
}

- (void)postConnectedToBroadcasterWithName:(NSString*)name {
	//NSString *message = [NSString stringWithFormat:@"Listening to %@", name];
}

- (void)dealloc {
    [super dealloc];
    
    [notificationWindow release];
    notificationWindow = nil;
    
    [nvc release];
    nvc = nil;
}

@end
