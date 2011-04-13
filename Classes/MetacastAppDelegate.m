//
//  MetacastAppDelegate.m
//  Djinn
//
//  Created by Ashley Steigerwalt on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MetacastAppDelegate.h"
#import "Growl.framework/Headers/GrowlApplicationBridge.h"


@implementation MetacastAppDelegate

@synthesize appState;
@synthesize statusMenu;
@synthesize mediaListener;

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification {
	
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	growlController = [[MCGrowlController alloc] init];
	[GrowlApplicationBridge setGrowlDelegate:growlController];
    
    server = [[Server alloc] init];
    [server start];
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

- (void)updateAppState {
    if (server.isRunning && mediaListener.currentSongData != nil) self.appState = @"Broadcasting";
    else if (mediaListener.currentSongData != nil) self.appState = @"Playing";
    else if (connection != nil && mediaListener.currentSongData != nil) self.appState = @"Listening";
    else if (connection != nil) self.appState = @"Connected";
    else self.appState = @"Idle";
}

- (void)dealloc {
	[growlController release];
	[mediaListener release];
	[super dealloc];

}

@end
