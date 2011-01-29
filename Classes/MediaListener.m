//
//  MediaListener.m
//  MetaCast
//
//  Created by Ashley Steigerwalt on 1/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MediaListener.h"
#import "MCStatusMenu.h"


@implementation MediaListener

- (id)init {
	if (self = [super init]) {
		[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedItunesNotification:) name:@"com.apple.iTunes.playerInfo" object:nil];
		NSLog(@"Registered listener");
	}
	
	return self;
}

- (void)receivedItunesNotification:(NSNotification *)mediaNotification {
	NSLog(@"Got notification");
	
	NSString *playerStatus = [[[mediaNotification userInfo] objectForKey:@"Player State"] description];
	
	if ([playerStatus isEqualToString:@"Paused"]) {
		[[MCStatusMenu sharedMCStatusMenu] setNoMediaInfo];
	} else {
		NSString *artist = [[[mediaNotification userInfo] objectForKey:@"Artist"] description];
		NSString *song = [[[mediaNotification userInfo] objectForKey:@"Name"] description];
		
		[[MCStatusMenu sharedMCStatusMenu] updateCurrentArtist:artist Song:song];
	}
}

- (void)dealloc {
	[super dealloc];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
