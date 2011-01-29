//
//  MCStatusMenu.m
//  MetaCast
//
//  Created by Ashley Steigerwalt on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MCStatusMenu.h"
#import "MCServer.h"

@interface MCStatusMenu(Private)

- (NSMenu*)metacastersMenu;

- (void)toggleMetacasting;
- (void)showPreferences;
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
		
		appMenu = [[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@"MetaCast"];
		
		[[appMenu addItemWithTitle:NSLocalizedString(@"Idle.", NULL) action:nil keyEquivalent:@""] setTag:kApplicationStatus];
		
		[appMenu addItem:[NSMenuItem separatorItem]];

		[[appMenu addItemWithTitle:NSLocalizedString(@"Nothing playing", NULL) action:nil keyEquivalent:@""] setTag:kNothingPlaying];
		
		[[appMenu addItemWithTitle:NSLocalizedString(@"Current Artist", NULL) action:nil keyEquivalent:@""] setTag:kCurrentArtist];
		[[appMenu itemWithTag:kCurrentArtist] setHidden:YES];
		
		[[appMenu addItemWithTitle:NSLocalizedString(@"Current Song", NULL) action:nil keyEquivalent:@""] setTag:kCurrentSong];
		[[appMenu itemWithTag:kCurrentSong] setHidden:YES];
		
		[appMenu addItem:[NSMenuItem separatorItem]];

		[[appMenu addItemWithTitle:NSLocalizedString(@"Allow Broadcast", NULL) action:@selector(toggleMetacasting) keyEquivalent:@""] setTag:kMetacastToggle];
		[[appMenu itemWithTag:kMetacastToggle] setTarget:self];
		
		[[appMenu addItemWithTitle:NSLocalizedString(@"Metacasters", NULL) action:nil keyEquivalent:@""] setTag:kMetacasters];
		[[appMenu itemWithTag:kMetacasters] setSubmenu:[self metacastersMenu]];
		
		[appMenu addItem:[NSMenuItem separatorItem]];
		
		[[appMenu addItemWithTitle:NSLocalizedString(@"Preferences", NULL) action:@selector(showPreferences) keyEquivalent:@","] setTag:kPreferences];
		[[appMenu itemWithTag:kPreferences] setTarget:self];
		
		[[appMenu addItemWithTitle:NSLocalizedString(@"Quit", NULL) action:@selector(exitApplication) keyEquivalent:@"Q"] setTag:kQuit];
		[[appMenu itemWithTag:kQuit] setTarget:self];
		
		
		[statusItem setMenu:appMenu];
	}
	
	return self;
}

- (void)setNoMediaInfo {
	[[appMenu itemWithTag:kNothingPlaying] setHidden:NO];
	[[appMenu itemWithTag:kCurrentArtist] setHidden:YES];
	[[appMenu itemWithTag:kCurrentSong] setHidden:YES];
}

- (void)updateCurrentArtist:(NSString*)artist Song:(NSString*)song {
	[[appMenu itemWithTag:kNothingPlaying] setHidden:YES];
	[[appMenu itemWithTag:kCurrentArtist] setHidden:NO];
	[[appMenu itemWithTag:kCurrentSong] setHidden:NO];
	
	[[appMenu itemWithTag:kCurrentArtist] setTitle:artist];
	[[appMenu itemWithTag:kCurrentSong] setTitle:song];
}

- (void)updateAppStatus:(NSString*)status {
	[[appMenu itemWithTag:kApplicationStatus] setTitle:status];
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

- (void)toggleMetacasting {
	NSMenuItem *item = [appMenu itemWithTag:kMetacastToggle];
	
	if ([item state] != NSOnState) {
		[item setState:NSOnState];
		[[MCServer sharedMCServer] startMetacasting];
		[self updateAppStatus:NSLocalizedString(@"Metacasting", NULL)];
	} else {
		[item setState:NSOffState];
		[[MCServer sharedMCServer] stopMetacasting];
		[self updateAppStatus:NSLocalizedString(@"Idle.", NULL)];
	}
}

- (void)showPreferences {
	
}

- (void)exitApplication {
	 [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
}

@end

