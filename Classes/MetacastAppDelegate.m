#import "MetacastAppDelegate.h"
#import "LocalMediaInfoSupplier.h"
#import "RemoteMediaInfoSupplier.h"
#import "NotificationController.h"
#import "BroadcasterMenuItemView.h"
#import "Broadcaster.h"
#import <ObjectiveMetrics/ObjectiveMetrics.h>

@implementation MetacastAppDelegate

@synthesize server;
@synthesize browser;
@synthesize statusMenu;
@synthesize listenersMenu;
@synthesize metacastersMenu;
@synthesize mediaInfoSupplier;
@synthesize noListeners;
@synthesize noMetacasters;
@synthesize alwaysNo;
@synthesize rdioPoller;
@synthesize spotifyPoller;

#pragma mark App Delegate Methods
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    preferences = [PreferencesController sharedInstance];
    
    server = [[Server alloc] init];
    browser = [[Browser alloc] init];
    [browser bind:@"localName" toObject:server withKeyPath:@"name" options:nil];
    
    [browser startBrowsing];
    
    self.mediaInfoSupplier = [[[LocalMediaInfoSupplier alloc] initWithServer:server] autorelease];
    if (preferences.allowBroadcasting && self.mediaInfoSupplier.mediaState != kMediaStateIdle) {
        [server start];
        [self.mediaInfoSupplier updateMediaProperties];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(availableBroadcasterAdded:) name:kAvailableBroadcasterAddedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(availableBroadcasterRemoved:) name:kAvailableBroadcasterRemovedNotification object:nil];
    
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedItunesNotification:) name:@"com.apple.iTunes.playerInfo" object:nil];
    
    self.alwaysNo = [NSNumber numberWithBool:NO];
    
    self.rdioPoller = [[RdioPoller alloc] init];
    self.spotifyPoller = [[SpotifyPoller alloc] init];
    
    [[DMTracker defaultTracker] startApp];
}

- (void)awakeFromNib {
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain]; 
    [statusItem setHighlightMode:YES];
    [statusItem setImage:[NSImage imageNamed:@"cymbal-icon-small.png"]];
    [statusItem setMenu:statusMenu];

}

- (void)applicationWillTerminate:(NSNotification *)notification {
    [server stop];
    [browser stopBrowsing];
}

#pragma mark Application Control

- (IBAction)toggleBroadcast:(id)sender {
    preferences.allowBroadcasting = !preferences.allowBroadcasting;
    
    if (!preferences.allowBroadcasting && server.isRunning) [server stop];
    if (preferences.allowBroadcasting && !server.isRunning && mediaInfoSupplier.mediaState != kMediaStateIdle) {
        if ([self.mediaInfoSupplier isKindOfClass:[LocalMediaInfoSupplier class]]) {
            [server start];
        } else {
            LocalMediaInfoSupplier *localSupplier = [[[LocalMediaInfoSupplier alloc] initWithServer:server] autorelease];
            [localSupplier updateMediaProperties];
            
            if (localSupplier.mediaState != kMediaStateIdle) {
                self.mediaInfoSupplier = localSupplier;
                [server start];
            }
        }
    }
    
    [mediaInfoSupplier updateMediaProperties];
}

- (IBAction)toggleShowDesktopNotifications:(id)sender {
    preferences.showDesktopNotification = !preferences.showDesktopNotification;
}

- (IBAction)toggleRunAtLogin:(id)sender {
    preferences.startAtLogin = !preferences.startAtLogin;
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
    SEL action = [menuItem action];
    
    if (action == @selector(toggleBroadcast:)) {
        [menuItem setState:preferences.allowBroadcasting];
    
    } else if (action == @selector(toggleShowDesktopNotifications:)) {
        [menuItem setState:preferences.showDesktopNotification];
    } else if (action == @selector(toggleRunAtLogin:)) {
        [menuItem setState:preferences.startAtLogin];
    }
    
    return YES;
}

- (void)availableBroadcasterAdded:(NSNotification*)notification {
    Broadcaster *broadcaster = [notification object];
    
    NSMenuItem *item = [metacastersMenu addItemWithTitle:[broadcaster name] action:nil keyEquivalent:@""];
    
    NSViewController *viewController = [[NSViewController alloc] initWithNibName:@"BroadcasterMenuItemView" bundle:nil];
    [item setRepresentedObject:broadcaster];
    
    BroadcasterMenuItemView *view = (BroadcasterMenuItemView*)viewController.view;
    [view bind:@"shareName" toObject:broadcaster withKeyPath:@"name" options:nil];
    [view bind:@"currentSongData" toObject:broadcaster withKeyPath:@"songData" options:nil];
    

    [item setView:view];
    [viewController release];
    
    [noMetacasters setHidden:[[metacastersMenu itemArray] count] > 1];
}

- (void)availableBroadcasterRemoved:(NSNotification*)notification {
    Broadcaster *broadcaster = [notification object];
    
    if ([self.mediaInfoSupplier isKindOfClass:[RemoteMediaInfoSupplier class]]) {
        RemoteMediaInfoSupplier *remote = (RemoteMediaInfoSupplier*)self.mediaInfoSupplier;
        if (remote.broadcaster == broadcaster) {
            self.mediaInfoSupplier = [[[LocalMediaInfoSupplier alloc] initWithServer:server] autorelease];
        }
    }
    
    int itemIndex = [metacastersMenu indexOfItemWithRepresentedObject:broadcaster];
    if (itemIndex == -1) return;
    
    [metacastersMenu removeItemAtIndex:itemIndex];
    [noMetacasters setHidden:[[metacastersMenu itemArray] count] > 1];
}

- (void)receivedItunesNotification:(NSNotification *)mediaNotification {
    if ([self.mediaInfoSupplier isKindOfClass:[LocalMediaInfoSupplier class]]) return;
    
    LocalMediaInfoSupplier *localMediaSupplier = [[[LocalMediaInfoSupplier alloc] initWithServer:server] autorelease];
    
    if (localMediaSupplier.mediaState != kMediaStateIdle) {
        
        self.mediaInfoSupplier = localMediaSupplier;
        
        if (preferences.allowBroadcasting && !server.isRunning)
            [server start];
    }
}

- (void)follow:(NSString*)shareName {
    [self trackEventWithName:@"Follow" value:@"Click"];
    
    [server stop];
    Broadcaster *broadcaster = [browser availableBroadcasterWithName:shareName];
    self.mediaInfoSupplier = [[[RemoteMediaInfoSupplier alloc] initWithBroadcaster:broadcaster] autorelease];
}

- (void)trackEventWithName:(NSString*)name value:(NSString*)value {
    NSLog(@"track %@ %@", name, value);
    [[DMTracker defaultTracker] trackEventInCategory:@"Cymbal" withName:[name stringByAppendingFormat:@" %@", value] value:value];
    NSLog(@"Done track, now flush");
    [[DMTracker defaultTracker] flushQueue];
    NSLog(@"Done flush");
}

#pragma mark Dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAvailableBroadcasterAddedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAvailableBroadcasterRemovedNotification object:nil];
    
    [server release];
    server = nil;
    
    [browser release];
    browser = nil;
    
    self.statusMenu = nil;
	self.mediaInfoSupplier = nil;
    self.alwaysNo = nil;
    
    self.rdioPoller = nil;
    self.spotifyPoller = nil;
    
	[super dealloc];

}

@end
