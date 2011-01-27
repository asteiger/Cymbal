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
	[mcServer startService];
}

- (void)awakeFromNib {
	mediaListener = [[MediaListener alloc] init];
}



- (void)dealloc {
	[mcServer stopService];
	[mcServer release];
	[mediaListener release];
	[super dealloc];

}

@end
