#import "MetacastAppDelegate.h"
#import "LocalMediaInfoSupplier.h"
#import "RemoteMediaInfoSupplier.h"
#import "NotificationController.h"



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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(availableServiceAdded:) name:kAvailableServiceAddedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(availableServiceRemoved:) name:kAvailableServiceRemovedNotification object:nil];
    
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedItunesNotification:) name:@"com.apple.iTunes.playerInfo" object:nil];
    
    [[self.noMetacasters parentItem] bind:@"enabled" toObject:server withKeyPath:@"isRunning" options:[NSDictionary dictionaryWithObject:NSNegateBooleanTransformerName 
                                                                                                                                  forKey:NSValueTransformerNameBindingOption]];
    [[self.noListeners parentItem] bind:@"enabled" 
                               toObject:server 
                            withKeyPath:@"isRunning" 
                                options:nil];
    
    self.alwaysNo = [NSNumber numberWithBool:NO];
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

- (IBAction)toggleAutoconnect:(id)sender {
    preferences.allowAutoconnect = !preferences.allowAutoconnect;
}

- (IBAction)toggleShowDesktopNotifications:(id)sender {
    preferences.showDesktopNotification = !preferences.showDesktopNotification;
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
    SEL action = [menuItem action];
    
    if (action == @selector(toggleBroadcast:)) {
        [menuItem setState:preferences.allowBroadcasting];
    
    } else if (action == @selector(didSelectMetacaster:)) {
        
    } else if (action == @selector(toggleAutoconnect:)) {
        [menuItem setState:preferences.allowAutoconnect];
    } else if (action == @selector(toggleShowDesktopNotifications:)) {
        [menuItem setState:preferences.showDesktopNotification];
    }
    
    return YES;
}

- (void)availableServiceAdded:(NSNotification*)notification {
    NSNetService *service = [notification object];

    [metacastersMenu addItemWithTitle:[service name] action:nil keyEquivalent:@""];
    if (preferences.allowAutoconnect && self.mediaInfoSupplier.mediaState == kMediaStateIdle) {
        // auto follow
    }
    
    [noMetacasters setHidden:[[metacastersMenu itemArray] count] > 1];
}

- (void)availableServiceRemoved:(NSNotification*)notification {
    NSNetService *service = [notification object];
    
    [metacastersMenu removeItem:[metacastersMenu itemWithTitle:[service name]]];
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

#pragma mark Dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAvailableServiceAddedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAvailableServiceRemovedNotification object:nil];
    
    [server release];
    server = nil;
    
    [browser release];
    browser = nil;
    
    self.statusMenu = nil;
	self.mediaInfoSupplier = nil;
    self.alwaysNo = nil;
    
	[super dealloc];

}

@end
