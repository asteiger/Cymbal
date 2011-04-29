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
        notifications = [[NSMutableArray arrayWithCapacity:1] retain];
        NSRect rect = [[NSScreen mainScreen] visibleFrame];
        NSPoint point = NSMakePoint(rect.size.width, rect.size.height - 20);
        
        nvc = [[NotificationViewController alloc] initWithNibName:@"NotificationViewController" bundle:nil];
        
        notificationWindow = [[MAAttachedWindow alloc] initWithView:nvc.view attachedToPoint:point onSide:MAPositionLeft atDistance:10];
        [notificationWindow setHasArrow:0];
        [notificationWindow setLevel:NSFloatingWindowLevel];
        
        originalViewFrame = nvc.view.frame;
    }
    
    return self;
}

- (void)notificationWindowWithTitle:(NSString*)title Subject1:(NSString*)subject1 Subject2:(NSString*)subject2 {
    @synchronized(self) {
        [timer fire];
        
        nvc.titleLine = title;
        nvc.subjectLine1 = subject1;
        nvc.subjectLine2 = subject2;
        
        if (nil == title) nvc.titleLine = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];;
        
        if (nil == subject2) {
            NSRect newFrame = originalViewFrame;
            newFrame.size.height = originalViewFrame.size.height-20;
            
            [nvc.view setFrame:newFrame];
        } else {
            [nvc.view setFrame:originalViewFrame];
        }
        
        [notificationWindow _updateGeometry];
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

- (void)postBroadcastStartedNotification {
    NSString *message = @"Broadcasting started";
    [self notificationWindowWithTitle:nil Subject1:message Subject2:nil];
}

- (void)postBroadcastStoppedNotification {
    NSString *message = @"Broadcasting stopped";
    [self notificationWindowWithTitle:nil Subject1:message Subject2:nil];
}

- (void)postConnectedToBroadcasterWithName:(NSString*)name {
	NSString *message = [NSString stringWithFormat:@"Listening to %@", name];
    [self notificationWindowWithTitle:nil Subject1:message Subject2:nil];
}

- (void)postDisconnectedFromBroadcasterWithName:(NSString*)name {
	NSString *message = [NSString stringWithFormat:@"Listening to %@", name];
    [self notificationWindowWithTitle:nil Subject1:message Subject2:nil];
}

- (void)dealloc {
    [super dealloc];
    
    [notifications release];
    [notificationWindow release];
    notificationWindow = nil;
    
    [nvc release];
    nvc = nil;
}

@end
