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
    browser = [[Browser alloc] initWithLocalName:server.name];
    [browser startBrowsing];
    
    self.mediaInfoSupplier = [[[LocalMediaInfoSupplier alloc] initWithServer:server] autorelease];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(availableServiceAdded:) name:kAvailableServiceAddedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(availableServiceRemoved:) name:kAvailableServiceRemovedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listenerConnected:) name:kListenerConnectedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listenerDisonnected:) name:kListenerDisconnectedNotification object:nil];
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
    
    browser.localName = server.name;
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
}

- (void)availableServiceRemoved:(NSNotification*)notification {
    NSString *serviceName = [[notification userInfo] objectForKey:kServiceNameKey];
    
    [metacastersMenu removeItem:[metacastersMenu itemWithTitle:serviceName]];
    [noMetacasters setHidden:[[metacastersMenu itemArray] count] > 1];
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
    
    self.mediaInfoSupplier = nil;
    self.mediaInfoSupplier = [[[RemoteMediaInfoSupplier alloc] initWithConnection:connection] autorelease];
    
    return YES;
}

- (void)listenerConnected:(NSNotification*)notification {
    NSString *listenerName = [[notification userInfo] objectForKey:kListenerNameKey];
    
    [listenersMenu addItemWithTitle:listenerName action:nil keyEquivalent:@""];
    [noListeners setHidden:[[listenersMenu itemArray] count] > 1];
}

- (void)listenerDisonnected:(NSNotification*)notification {
    NSString *listenerName = [[notification userInfo] objectForKey:kListenerNameKey];
    
    [listenersMenu removeItem:[listenersMenu itemWithTitle:listenerName]];
    [noListeners setHidden:[[listenersMenu itemArray] count] > 1];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAvailableServiceAddedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAvailableServiceRemovedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kListenerConnectedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kListenerDisconnectedNotification object:nil];
    
    [server release];
    server = nil;
    
    [browser release];
    browser = nil;
    
    [connection release];
    connection = nil;
    
	[growlController release];
    growlController = nil;
    
    self.statusMenu = nil;
	self.mediaInfoSupplier = nil;
    
	[super dealloc];

}

@end
