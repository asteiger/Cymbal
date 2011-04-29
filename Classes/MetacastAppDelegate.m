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
@synthesize broadcastEnabled;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    broadcastEnabled = YES;
    
    server = [[Server alloc] init];
    browser = [[Browser alloc] init];
    [browser bind:@"localName" toObject:server withKeyPath:@"name" options:nil];
    
    [browser startBrowsing];
    
    self.mediaInfoSupplier = [[[LocalMediaInfoSupplier alloc] initWithServer:server] autorelease];
    if (self.mediaInfoSupplier.mediaState != kMediaStateIdle) {
        [server start];
        [self.mediaInfoSupplier updateMediaProperties];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(availableServiceAdded:) name:kAvailableServiceAddedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(availableServiceRemoved:) name:kAvailableServiceRemovedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listenerConnected:) name:kListenerConnectedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listenerDisonnected:) name:kConnectionDisconnectedNotification object:nil];
    
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
    [statusItem setImage:[NSImage imageNamed:@"icon-small.png"]];
    [statusItem setMenu:statusMenu];

}

- (void)applicationWillTerminate:(NSNotification *)notification {
    [server stop];
    [connection disconnect];
    [browser stopBrowsing];
}

- (IBAction)toggleBroadcast:(id)sender {
    self.broadcastEnabled = !self.broadcastEnabled;
    
    if (!self.broadcastEnabled && server.isRunning) [server stop];
    if (self.broadcastEnabled && !server.isRunning && mediaInfoSupplier.mediaState != kMediaStateIdle) [server start];
    [mediaInfoSupplier updateMediaProperties];
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
    NSLog(@"Validating menu item");
    
    SEL action = [menuItem action];
    
    if (action == @selector(toggleBroadcast:)) {
        [menuItem setState:self.broadcastEnabled];
    
    } else if (action == @selector(didSelectMetacaster:)) {
        if ([connection isConnected])
            [menuItem setState:[[menuItem title] isEqualToString:connection.remoteName]];
    }
    
    return YES;
}

- (void)availableServiceAdded:(NSNotification*)notification {
    NSNetService *service = [notification object];

    NSMenuItem *metacasterItem = [metacastersMenu addItemWithTitle:[service name] action:@selector(didSelectMetacaster:) keyEquivalent:@""];
    if (self.mediaInfoSupplier.mediaState == kMediaStateIdle && (connection == nil || ![connection isConnected]))
        [self didSelectMetacaster:metacasterItem];
    
    [noMetacasters setHidden:[[metacastersMenu itemArray] count] > 1];
}

- (void)availableServiceRemoved:(NSNotification*)notification {
    NSNetService *service = [notification object];
    
    [metacastersMenu removeItem:[metacastersMenu itemWithTitle:[service name]]];
    [noMetacasters setHidden:[[metacastersMenu itemArray] count] > 1];
}

- (void)didSelectMetacaster:(NSMenuItem*)sender {
    [self connectToMetacasterWithName:[sender title]];
}

- (BOOL)connectToMetacasterWithName:(NSString*)name {
    if (connection != nil) {
        if ([name isEqualToString:connection.remoteName]) return YES;
        
        [connection disconnect];
        [connection release];
        connection = nil;
    }
    
    NSNetService *service = [browser serviceWithName:name];
    if (service != nil) {
        connection = [[Connection alloc] initWithNetService:service LocalName:[[NSHost currentHost] localizedName]];
    
        self.mediaInfoSupplier = nil;
        self.mediaInfoSupplier = [[[RemoteMediaInfoSupplier alloc] initWithConnection:connection] autorelease];
        
        [[NotificationController sharedInstance] postConnectedToBroadcasterWithName:name];
        return YES;
    }
    
    return NO;
}

- (void)listenerConnected:(NSNotification*)notification {
    Connection *c = [notification object];
    
    NSMenuItem *item = [[[NSMenuItem alloc] initWithTitle:c.remoteName action:nil keyEquivalent:@""] autorelease];
    
    [item setRepresentedObject:c];
    [item bind:@"title" toObject:c withKeyPath:@"remoteName" options:nil];
    [item bind:@"enabled" toObject:self withKeyPath:@"alwaysNo" options:nil];
    
    [listenersMenu addItem:item];
    
    [noListeners setHidden:[[listenersMenu itemArray] count] > 1];
}

- (void)listenerDisonnected:(NSNotification*)notification {
    Connection *c = [notification object];
    if (c == connection) {
        [[NotificationController sharedInstance] postDisconnectedFromBroadcasterWithName:c.remoteName];
        [connection release];
        connection = nil;
        return;
    }
    
    NSInteger index;
    if (-1 == (index = [listenersMenu indexOfItemWithRepresentedObject:c])) return;
    
    [listenersMenu removeItem:[listenersMenu itemAtIndex:index]];
    [noListeners setHidden:[[listenersMenu itemArray] count] > 1];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAvailableServiceAddedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAvailableServiceRemovedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kListenerConnectedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kConnectionDisconnectedNotification object:nil];
    
    [server release];
    server = nil;
    
    [browser release];
    browser = nil;
    
    [connection release];
    connection = nil;
    
    self.statusMenu = nil;
	self.mediaInfoSupplier = nil;
    self.alwaysNo = nil;
    
	[super dealloc];

}

@end
