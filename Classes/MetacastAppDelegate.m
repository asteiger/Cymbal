#import "MetacastAppDelegate.h"
#import "LocalMediaInfoSupplier.h"
#import "RemoteMediaInfoSupplier.h"
#import "Growl.framework/Headers/GrowlApplicationBridge.h"


@implementation MetacastAppDelegate

@synthesize statusMenu;
@synthesize mediaInfoSupplier;

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification {
	
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	growlController = [[MCGrowlController alloc] init];
	[GrowlApplicationBridge setGrowlDelegate:growlController];
    
    server = [[Server alloc] init];
    [server start];
    
    self.mediaInfoSupplier = [[[LocalMediaInfoSupplier alloc] initWithServer:server] autorelease];
}

- (void)awakeFromNib {
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain]; 
    [statusItem setHighlightMode:YES];
    [statusItem setImage:[NSImage imageNamed:@"icon-small.png"]];
    [statusItem setMenu:statusMenu];
}

- (IBAction)toggleBroadcast:(id)sender {
    if (server.isRunning) {
        [server stop];
        self.mediaInfoSupplier = nil;
        self.mediaInfoSupplier = [[[RemoteMediaInfoSupplier alloc] initWithConnection:connection] autorelease];
    }
    else {
        [server start];
        self.mediaInfoSupplier = nil;
        self.mediaInfoSupplier = [[[LocalMediaInfoSupplier alloc] initWithServer:server] autorelease];
    }
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
    NSLog(@"Validating menu item");
    
    SEL action = [menuItem action];
    
    if (action == @selector(toggleBroadcast:)) {
        [menuItem setState:server.isRunning];
    }
    
    return YES;
}

- (void)dealloc {
	[growlController release];
    growlController = nil;
    
    self.statusMenu = nil;
	self.mediaInfoSupplier = nil;
    
	[super dealloc];

}

@end
