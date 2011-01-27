//
//  MCStatusMenu.m
//  MetaCast
//
//  Created by Ashley Steigerwalt on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MCStatusMenu.h"


@implementation MCStatusMenu

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
	NSMenu *metacastersMenu = [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:NSLocalizedString(@"Metacasters", NULL)] autorelease];
	[metacastersMenu addItemWithTitle:NSLocalizedString(@"No Metacasters Found", NULL) action:nil keyEquivalent:@""];
	
	return metacastersMenu;
}

- (void)dealloc {
	[statusItem release];
	[super dealloc];
}

@end
