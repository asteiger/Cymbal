#import "MetacastAppDelegate.h"
#import "LocalMediaInfoSupplier.h"
#import "RemoteMediaInfoSupplier.h"
#import "Growl.framework/Headers/GrowlApplicationBridge.h"


@implementation MetacastAppDelegate

@synthesize browser;
@synthesize statusMenu;
@synthesize listenersMenu;
@synthesize metacastersMenu;
@synthesize mediaInfoSupplier;
@synthesize noListeners;
@synthesize noMetacasters;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	growlController = [[MCGrowlController alloc] init];
	[GrowlApplicationBridge setGrowlDelegate:growlController];
    
    server = [[Server alloc] init];
    browser = [[Browser alloc] init];
    [browser startBrowsing];
    
    self.mediaInfoSupplier = [[[LocalMediaInfoSupplier alloc] initWithServer:server] autorelease];
    
    if (self.mediaInfoSupplier.mediaState == kMediaStateIdle) {
        self.mediaInfoSupplier = nil;
        self.mediaInfoSupplier = [[[RemoteMediaInfoSupplier alloc] initWithConnection:connection] autorelease];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(availableServiceAdded:) name:kAvailableServiceAddedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(availableServiceRemoved:) name:kAvailableServiceRemovedNotification object:nil];
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
    if (server.isRunning) [server stop];
    else [server start];
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
    NSLog(@"Validating menu item");
    
    SEL action = [menuItem action];
    
    if (action == @selector(toggleBroadcast:)) {
        [menuItem setState:server.isRunning];
    
    } else if (action == @selector(didSelectMetacaster:)) {
        if ([connection isConnected])
            [menuItem setState:[[menuItem title] isEqualToString:connection.remoteName]];
    }
    
    return YES;
}

- (void)availableServiceAdded:(NSNotification*)notification {
    NSString *serviceName = [[notification userInfo] objectForKey:kServiceNameKey];
    
    [metacastersMenu addItemWithTitle:serviceName action:@selector(didSelectMetacaster:) keyEquivalent:@""];
    [noMetacasters setHidden:[[metacastersMenu itemArray] count] > 1];
    [metacastersMenu update];
}

- (void)availableServiceRemoved:(NSNotification*)notification {
    NSString *serviceName = [[notification userInfo] objectForKey:kServiceNameKey];
    
    [metacastersMenu removeItem:[metacastersMenu itemWithTitle:serviceName]];
    [noMetacasters setHidden:[[metacastersMenu itemArray] count] > 1];
    [metacastersMenu update];
}

- (void)didSelectMetacaster:(NSMenuItem*)sender {
    [sender setState:[self connectToMetacasterWithName:[sender title]]];
}

- (BOOL)connectToMetacasterWithName:(NSString*)name {
    if (connection != nil) {
        [connection disconnect];
        [connection release];
        connection = nil;
    }
    
    NSNetService *service = [browser serviceWithName:name];
    if (service == nil) return NO;
    
    connection = [[Connection alloc] initWithNetService:service LocalName:[[NSHost currentHost] localizedName]];
    return YES;
}

- (void)listenerConnected:(NSNotification*)notification {
    
}

- (void)listenerDisonnected:(NSNotification*)notification {
    
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAvailableServiceAddedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAvailableServiceRemovedNotification object:nil];
    
    [connection release];
    connection = nil;
    
	[growlController release];
    growlController = nil;
    
    self.statusMenu = nil;
	self.mediaInfoSupplier = nil;
    
	[super dealloc];

}

@end
