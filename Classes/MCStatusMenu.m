//
//  MCStatusMenu.m
//  Djinn
//
//  Created by Ashley Steigerwalt on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MCStatusMenu.h"
#import "MCBroadcaster.h"
#import "MCGrowlController.h"

@interface MCStatusMenu(Private)

- (void)didSelectMetacasterMenuItem:(NSMenuItem*)sender;

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
		//[statusItem setTitle:NSLocalizedString(@"Djinn", NULL)];
		[statusItem setHighlightMode:YES];
		[statusItem setImage:[NSImage imageNamed:@"icon-small.png"]];
		
		appMenu = [[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@"MetaCast"];
		
		[[appMenu addItemWithTitle:NSLocalizedString(@"Status", NULL) action:nil keyEquivalent:@""] setTag:kApplicationStatus];
		[[appMenu addItemWithTitle:NSLocalizedString(@"Listeners", NULL) action:nil keyEquivalent:@""] setTag:kListeners];
		[[appMenu itemWithTag:kListeners] setHidden:YES];
		[[appMenu itemWithTag:kListeners] setSubmenu:[[[NSMenu alloc] initWithTitle:@"Listeners"] autorelease]];
		
		[appMenu addItem:[NSMenuItem separatorItem]];

		[[appMenu addItemWithTitle:NSLocalizedString(@"Nothing playing", NULL) action:nil keyEquivalent:@""] setTag:kNothingPlaying];
		
		[[appMenu addItemWithTitle:NSLocalizedString(@"Current Artist", NULL) action:nil keyEquivalent:@""] setTag:kCurrentArtist];
		[[appMenu itemWithTag:kCurrentArtist] setHidden:YES];
		
		[[appMenu addItemWithTitle:NSLocalizedString(@"Current Song", NULL) action:nil keyEquivalent:@""] setTag:kCurrentSong];
		[[appMenu itemWithTag:kCurrentSong] setHidden:YES];
		
		[appMenu addItem:[NSMenuItem separatorItem]];

		[[appMenu addItemWithTitle:NSLocalizedString(@"Toggle Broadcast", NULL) action:@selector(toggleMetacasting) keyEquivalent:@""] setTag:kMetacastToggle];
		[[appMenu itemWithTag:kMetacastToggle] setTarget:self];
		[[appMenu itemWithTag:kMetacastToggle] setState:NSOnState];
		
		[[appMenu addItemWithTitle:NSLocalizedString(@"Metacasters", NULL) action:nil keyEquivalent:@""] setTag:kMetacasters];
		[[appMenu itemWithTag:kMetacasters] setSubmenu:[self metacastersMenu]];
		
		[appMenu addItem:[NSMenuItem separatorItem]];
		
		[[appMenu addItemWithTitle:NSLocalizedString(@"Preferences", NULL) action:@selector(showPreferences) keyEquivalent:@","] setTag:kPreferences];
		[[appMenu itemWithTag:kPreferences] setTarget:self];
		
		[[appMenu addItemWithTitle:NSLocalizedString(@"Quit Djinn", NULL) action:@selector(exitApplication) keyEquivalent:@""] setTag:kQuit];
		[[appMenu itemWithTag:kQuit] setTarget:self];
		
		
		[statusItem setMenu:appMenu];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAppStatusMenuItem:) name:@"ApplicationStateChanged" object:nil];
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

- (void)updateAppStatusMenuItem {
	NSString *statusText = nil;
	MCApplicationController *stateController = [MCApplicationController sharedApplicationController];
											 
	switch ([stateController applicationState]) {
		case kIdle:
			statusText = NSLocalizedString(@"Idle", NULL);
			break;
			
		case kPlaying:
			statusText = [stateController isBroadcastingEnabled] ? NSLocalizedString(@"Broadcasting", NULL) : NSLocalizedString(@"Playing", NULL);
			break;
			
		case kListening:
			statusText = NSLocalizedString(@"Listening", NULL);
			break;

		default:
			break;
	}
	
	[[appMenu itemWithTag:kApplicationStatus] setTitle:statusText];
}

- (void)addBroadcaster:(MCBroadcaster*)metacaster {
	NSMenu *metacastersMenu = [[appMenu itemWithTag:kMetacasters] submenu];
	NSMenuItem *metacasterItem = [metacastersMenu addItemWithTitle:[metacaster.service name] action:@selector(didSelectMetacasterMenuItem:) keyEquivalent:@""];
	
	[metacasterItem setTarget:self];
	[metacasterItem setRepresentedObject:metacaster];
}

- (void)dealloc {
	[statusItem release];
	[super dealloc];
}

@end

@implementation MCStatusMenu(Private)

- (void)didSelectMetacasterMenuItem:(NSMenuItem*)sender {
	
	MCBroadcaster *metacaster = [sender representedObject];
	metacaster.connected = YES;
	// TODO: connect to metacaster for listening
}

- (NSMenu*)metacastersMenu {
	NSMenu *metacastersMenu = [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:NSLocalizedString(@"Metacasters", NULL)] autorelease];
	[metacastersMenu addItemWithTitle:NSLocalizedString(@"No Metacasters Found", NULL) action:nil keyEquivalent:@""];
	
	return metacastersMenu;
}

- (void)toggleMetacasting {
	NSMenuItem *item = [appMenu itemWithTag:kMetacastToggle];
	
	if ([item state] != NSOnState) {
		[item setState:NSOnState];
		
	} else {
		[item setState:NSOffState];
		
	}
	
	[MCGrowlController postBroadcastEnabledNotificationWithState:[item state]];
}

- (void)showPreferences {
	
}

- (void)exitApplication {
	 [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
}

@end

