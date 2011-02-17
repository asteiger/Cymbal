//
//  MCAppStateController.m
//  Djinn
//
//  Created by Ashley Steigerwalt on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MCApplicationController.h"


@implementation MCApplicationController

static MCApplicationController *sharedInstance;
+ (MCApplicationController*)sharedApplicationController {
	if (nil == sharedInstance) {
		sharedInstance = [[self alloc] init];
	}
	
	return sharedInstance;
}

- (id)init {
	if (self = [super init]) {
		server = [[Server alloc] init];
		[server start];
	}
	
	return self;
}

- (void)setApplicationState:(MCApplicationState)state {
	if (state == _appState) return;
	
	_appState = state;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ApplicationStateChanged" object:self];
}

- (MCApplicationState)applicationState {
	return _appState;
}

- (void)setBroadcastingIsEnabled:(BOOL)enabled {
	_broadcastingEnabled = enabled;
}

- (BOOL)isBroadcastingEnabled {
	return _broadcastingEnabled;
}

- (BOOL)isConnectedToBroadcaster {
	return NO;
}

- (void)broadcast {
	[server broadcastSongData:nil];
}

@end