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
	mcServer = [[MCServer alloc] init];
	[mcServer startMetacasting];
}

- (void)awakeFromNib {
	[MCStatusMenu sharedMCStatusMenu];
	mediaListener = [[MediaListener alloc] init];
}



- (void)dealloc {
	[mcServer stopMetacasting];
	[mcServer release];
	[mediaListener release];
	[super dealloc];

}

@end
