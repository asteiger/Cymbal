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
		[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedItunesNotification) name:@"com.apple.iTunes.playerInfo" object:nil];
		NSLog(@"Registered listener");
	}
	
	return self;
}

- (void)receivedItunesNotification {
	NSLog(@"Got notification");
}

- (void)dealloc {
	[super dealloc];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
