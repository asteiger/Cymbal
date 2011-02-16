//
//  MCAppStateController.h
//  Djinn
//
//  Created by Ashley Steigerwalt on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MCServer.h"
#import "MCConnection.h"

typedef enum {
	kIdle = 1,
	kPlaying = 2,
	kListening = 3
} MCApplicationState;

@interface MCApplicationController : NSObject {
	MCApplicationState _appState;
	BOOL _broadcastingEnabled;
	MCServer *server;
	MCConnection *listeningConnection;
}

+ (MCApplicationController*)sharedApplicationController;

- (void)setApplicationState:(MCApplicationState)state;
- (void)setBroadcastingIsEnabled:(BOOL)enabled;

- (BOOL)isBroadcastingEnabled;
- (BOOL)isConnectedToBroadcaster;
- (MCApplicationState)applicationState;

@end
