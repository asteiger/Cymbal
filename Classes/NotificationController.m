#import "NotificationController.h"
#import "NotificationViewController.h"

@implementation NotificationController

@synthesize notificationWindow;

NotificationController *instance;
+ (NotificationController*)sharedInstance {
    if (nil == instance) {
        instance = [[self alloc] init];
    }
    
    return instance;
}

- (void)notificationWindowWithTitle:(NSString*)title Subject1:(NSString*)subject1 Subject2:(NSString*)subject2 {
    NSRect rect = [[NSScreen mainScreen] visibleFrame];
    NSPoint point = NSMakePoint(rect.size.width, rect.size.height - 20);
    
    NotificationViewController *nvc = [[[NotificationViewController alloc] initWithNibName:@"NotificationViewController" bundle:nil] autorelease];
    
    nvc.titleLine = title;
    nvc.subjectLine1 = subject1;
    nvc.subjectLine2 = subject2;
    
    [timer invalidate];
    [timer release];
    
    [self.notificationWindow orderOut:self];
    self.notificationWindow = nil;
    
    self.notificationWindow = [[[MAAttachedWindow alloc] initWithView:[nvc view] attachedToPoint:point onSide:MAPositionLeft atDistance:10] autorelease];
    
    [self.notificationWindow setHasArrow:0];
    [self.notificationWindow setLevel:NSFloatingWindowLevel];
    [self.notificationWindow setAlphaValue:0.0];
    [self.notificationWindow setReleasedWhenClosed:NO];
    [self.notificationWindow orderFront:self];
    
    [NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:0.4];	
	[[self.notificationWindow animator] setAlphaValue:1.0];
	[NSAnimationContext endGrouping];
    
    timer = [[NSTimer timerWithTimeInterval:3 target:self selector:@selector(timerFire:) userInfo:nil repeats:NO] retain];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)timerFire:(NSTimer*)aTimer {
    
    [NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:0.4];	
	[[self.notificationWindow animator] setAlphaValue:0.0];
	[NSAnimationContext endGrouping];
    [[self.notificationWindow animator] startAnimation];
    
    [self.notificationWindow orderOut:self];
    self.notificationWindow = nil;
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

@end
