//
//  MetaCastAppDelegate.m
//  MetaCast
//
//  Created by Ashley Steigerwalt on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MetaCastAppDelegate.h"

@implementation MetaCastAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
}

- (void)awakeFromNib {
	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain]; 
	[statusItem setTitle:NSLocalizedString(@"MC", NULL)];
	[statusItem setHighlightMode:YES];
	
	NSMenu *statusMenu = [[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@"MetaCast"];
	
	NSMenuItem *menuItem = [statusMenu addItemWithTitle:NSLocalizedString(@"Metacasters", NULL) action:nil keyEquivalent:@""];
	[menuItem setSubmenu:[self metacastersMenu]];
	
	[statusItem setMenu:statusMenu];
}

- (NSMenu*)metacastersMenu {
	NSMenu *metacastersMenu = [[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:NSLocalizedString(@"Metacasters", NULL)];
	[metacastersMenu addItemWithTitle:NSLocalizedString(@"No Metacasters Found", NULL) action:nil keyEquivalent:@""];

	return metacastersMenu;
}

@end
