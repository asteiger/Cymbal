//
//  DjinnAppDelegate.m
//  Djinn
//
//  Created by Ashley Steigerwalt on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DjinnAppDelegate.h"
#import "MCServer.h"
#import "MCStatusMenu.h"
#import "Growl.framework/Headers/GrowlApplicationBridge.h"


@implementation MetaCastAppDelegate

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification {
	// TODO: check to valid license
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	growlController = [[MCGrowlController alloc] init];
	[GrowlApplicationBridge setGrowlDelegate:growlController];
	
	[[MCServer sharedMCServer] startMetacasting];
}

- (void)awakeFromNib {
	[MCStatusMenu sharedMCStatusMenu];
	mediaListener = [[MediaListener alloc] init];
}

- (void)dealloc {
	[growlController release];
	[mediaListener release];
	[super dealloc];

}

@end
