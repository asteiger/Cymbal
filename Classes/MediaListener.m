//
//  MediaListener.m
//  Djinn
//
//  Created by Ashley Steigerwalt on 1/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MediaListener.h"

@implementation MediaListener

static const NSString *ItunesStopped = @"Stopped";
static const NSString *ItunesPaused = @"Paused";

- (id)init {
	if (self = [super init]) {
		[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedItunesNotification:) name:@"com.apple.iTunes.playerInfo" object:nil];
		NSLog(@"Registered iTunes listener");
	}
	
	return self;
}

- (void)receivedItunesNotification:(NSNotification *)mediaNotification {
	NSLog(@"Got iTunes notification");
	
	NSString *playerState = [[[mediaNotification userInfo] objectForKey:@"Player State"] description];
	NSString *artist = [[[mediaNotification userInfo] objectForKey:@"Artist"] description];
	NSString *song = [[[mediaNotification userInfo] objectForKey:@"Name"] description];
	
	if ([playerState isEqualToString:ItunesStopped] || [playerState isEqualToString:ItunesPaused]) {
		[[MCApplicationController sharedApplicationController] setApplicationState:kIdle];
		[[MCStatusMenu sharedMCStatusMenu] setNoMediaInfo];
	} else {
		[[MCApplicationController sharedApplicationController] setApplicationState:kPlaying];
		[[MCStatusMenu sharedMCStatusMenu] updateCurrentArtist:artist Song:song];
		[[MCApplicationController sharedApplicationController] broadcast];
	}
}

- (void)dealloc {
	[super dealloc];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
