//
//  MCStatusMenu.m
//  MetaCast
//
//  Created by Ashley Steigerwalt on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MCStatusMenu.h"

@interface MCStatusMenu(Private)

- (NSMenu*)metacastersMenu;
- (void)exitApplication;

@end


@implementation MCStatusMenu

static MCStatusMenu *sharedInstance = nil;
+ (MCStatusMenu*)sharedMCStatusMenu {
	if (nil == sharedInstance) {
		sharedInstance = [[self alloc] init];
	}
	
	return sharedInstance;
}

- (id)init {
	if (self = [super init]) {
		statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain]; 
		[statusItem setTitle:NSLocalizedString(@"MC", NULL)];
		[statusItem setHighlightMode:YES];
		
		NSMenu *statusMenu = [[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@"MetaCast"];
		
		appStatus = [statusMenu addItemWithTitle:NSLocalizedString(@"Idle.", NULL) action:nil keyEquivalent:@""];
		
		[statusMenu addItem:[NSMenuItem separatorItem]];
		
		NSMenuItem *menuItem = [statusMenu addItemWithTitle:NSLocalizedString(@"Metacasters", NULL) action:nil keyEquivalent:@""];
		[menuItem setSubmenu:[self metacastersMenu]];
		
		[[statusMenu addItemWithTitle:NSLocalizedString(@"Quit", NULL) action:@selector(exitApplication) keyEquivalent:@""] setTarget:self];
		
		
		[statusItem setMenu:statusMenu];
	}
	
	return self;
}

- (void)updateAppStatus:(NSString*)status {
	[appStatus setTitle:status];
}

- (void)addMetacaster:(NSString*)name {
	// add a listenable source
}

- (void)dealloc {
	[statusItem release];
	[super dealloc];
}

@end

@implementation MCStatusMenu(Private)

- (NSMenu*)metacastersMenu {
	NSMenu *metacastersMenu = [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:NSLocalizedString(@"Metacasters", NULL)] autorelease];
	[metacastersMenu addItemWithTitle:NSLocalizedString(@"No Metacasters Found", NULL) action:nil keyEquivalent:@""];
	
	return metacastersMenu;
}

- (void)exitApplication {
	 [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
}

@end

