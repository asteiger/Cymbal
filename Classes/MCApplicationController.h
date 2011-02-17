//
//  MCAppStateController.h
//  Djinn
//
//  Created by Ashley Steigerwalt on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Server.h"

typedef enum {
	kIdle = 1,
	kPlaying = 2,
	kListening = 3
} MCApplicationState;

@interface MCApplicationController : NSObject {
	Server *server;
	MCApplicationState _appState;
	BOOL _broadcastingEnabled;
}

+ (MCApplicationController*)sharedApplicationController;

- (void)setApplicationState:(MCApplicationState)state;
- (void)setBroadcastingIsEnabled:(BOOL)enabled;

- (BOOL)isBroadcastingEnabled;
- (BOOL)isConnectedToBroadcaster;
- (MCApplicationState)applicationState;

- (void)broadcast;

@end
