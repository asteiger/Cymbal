//
//  MediaListener.m
//  MetaCast
//
//  Created by Ashley Steigerwalt on 1/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MediaListener.h"


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
	NSLog(@"%@", [[[mediaNotification userInfo] objectForKey:@"Player State"] description]);
	NSLog(@"%@", [[[mediaNotification userInfo] objectForKey:@"Locations"] description]);
	NSLog(@"%@", [[[mediaNotification userInfo] objectForKey:@"Name"] description]);
}

- (void)dealloc {
	[super dealloc];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
