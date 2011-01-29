//
//  MetaCastAppDelegate.m
//  MetaCast
//
//  Created by Ashley Steigerwalt on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MetaCastAppDelegate.h"

@implementation MetaCastAppDelegate

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification {
	// TODO: check to valid license
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[[MCServer sharedMCServer] startMetacasting];
}

- (void)awakeFromNib {
	[MCStatusMenu sharedMCStatusMenu];
	mediaListener = [[MediaListener alloc] init];
}

- (void)dealloc {
	[mediaListener release];
	[super dealloc];

}

@end
