#import "NotificationController.h"
#import "PreferencesController.h"

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
        notifications = [[NSMutableArray arrayWithCapacity:0] retain];
        
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
    if ([title isEqualToString:@""]) title = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    
    NSDictionary *notification = [NSDictionary dictionaryWithObjectsAndKeys:
                                  title, @"title",
                                  subject1, @"subject1",
                                  subject2, @"subject2", nil];
    
    [notifications addObject:notification];
    if ([notifications count] == 1) [self postNextNotification];
}

- (void)postNextNotification {
    if (![PreferencesController sharedInstance].showDesktopNotification) return;
    if ([notifications count] == 0) return;
    
    NSDictionary *headObject = [notifications objectAtIndex:0];

    nvc.titleLine = [headObject objectForKey:@"title"];
    nvc.subjectLine1 = [headObject objectForKey:@"subject1"];
    nvc.subjectLine2 = [headObject objectForKey:@"subject2"];
    
    if ([nvc.subjectLine2 isEqualToString:@""]) {
        NSRect newFrame = originalViewFrame;
        newFrame.size.height = originalViewFrame.size.height-20;
        
        [nvc.view setFrame:newFrame];
    } else {
        [nvc.view setFrame:originalViewFrame];
    }
    
    [notificationWindow _updateGeometry];
    [notificationWindow setAlphaValue:0.0];
    [notificationWindow orderFront:self];
    
    NSMutableDictionary *animationDict = [NSMutableDictionary dictionaryWithCapacity:2];
    [animationDict setObject:notificationWindow forKey:NSViewAnimationTargetKey];
    [animationDict setObject:NSViewAnimationFadeInEffect forKey:NSViewAnimationEffectKey];
    
    NSViewAnimation *animation = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObject:animationDict]];
    [animation setDuration:0.5];
    [animation startAnimation];
    [animation release];
           
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSMutableDictionary *animationDict = [NSMutableDictionary dictionaryWithCapacity:2];
        [animationDict setObject:notificationWindow forKey:NSViewAnimationTargetKey];
        [animationDict setObject:NSViewAnimationFadeOutEffect forKey:NSViewAnimationEffectKey];
        
        NSViewAnimation *animation = [[NSViewAnimation alloc] initWithViewAnimations:[NSArray arrayWithObject:animationDict]];
        [animation setDuration:0.5];
        [animation setAnimationBlockingMode:NSAnimationBlocking];
        [animation startAnimation];
        [animation release];
        
        [notificationWindow orderOut:self];
        
        [timer invalidate];
        [timer release];
        timer = nil;
        
        [notifications removeObjectAtIndex:0];
        [self postNextNotification];
    });
}

- (void)postNotificationWithSong:(MCSongData*)songData {
    NSLog(@"Posting song notification");
    
    [self notificationWindowWithTitle:songData.songTitle Subject1:songData.artist Subject2:songData.album];
}

- (void)postBroadcastStartedNotification {
    NSString *message = @"Broadcasting started";
    [self notificationWindowWithTitle:@"" Subject1:message Subject2:@""];
}

- (void)postBroadcastStoppedNotification {
    NSString *message = @"Broadcasting stopped";
    [self notificationWindowWithTitle:@"" Subject1:message Subject2:@""];
}

- (void)postConnectedToBroadcasterWithName:(NSString*)name {
	NSString *message = [NSString stringWithFormat:@"Listening to %@", name];
    [self notificationWindowWithTitle:@"" Subject1:message Subject2:@""];
}

- (void)postDisconnectedFromBroadcasterWithName:(NSString*)name {
	NSString *message = [NSString stringWithFormat:@"Disconnected from %@", name];
    [self notificationWindowWithTitle:@"" Subject1:message Subject2:@""];
}

- (void)postListenerConnectedWithName:(NSString*)name {
    NSString *message = [NSString stringWithFormat:@"New listener connected", name];
    [self notificationWindowWithTitle:@"" Subject1:message Subject2:@""];
}

- (void)postListenerDisconnectedWithName:(NSString*)name {
    NSString *message = [NSString stringWithFormat:@"%@ disconnected", name];
    [self notificationWindowWithTitle:@"" Subject1:message Subject2:@""];
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
