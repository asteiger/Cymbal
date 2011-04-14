#import "MetacastAppDelegate.h"
#import "LocalMediaController.h"
#import "Growl.framework/Headers/GrowlApplicationBridge.h"


@implementation MetacastAppDelegate

@synthesize statusMenu;
@synthesize mediaController;

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification {
	
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	growlController = [[MCGrowlController alloc] init];
	[GrowlApplicationBridge setGrowlDelegate:growlController];
    
    server = [[Server alloc] init];
    [server start];
    
    self.mediaController = [[[LocalMediaController alloc] initWithServer:server] autorelease];
}

- (void)awakeFromNib {
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain]; 
    [statusItem setHighlightMode:YES];
    [statusItem setImage:[NSImage imageNamed:@"icon-small.png"]];
    [statusItem setMenu:statusMenu];
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
    }
    
    return YES;
}

- (void)dealloc {
	[growlController release];
    growlController = nil;
    
    self.statusMenu = nil;
	self.mediaController = nil;
    
	[super dealloc];

}

@end
