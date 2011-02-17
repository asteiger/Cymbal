//
//  Server.h
//  Djinn
//
//  Created by Ashley Steigerwalt on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AsyncSocket.h"
#import "MCSongData.h"

@interface Server : NSObject {
	AsyncSocket *serverSocket;
	NSMutableArray *connectedSockets;
	BOOL isRunning;
}

- (void)start;
- (void)stop;
- (void)broadcastSongData:(MCSongData*)songData;
- (BOOL)isRunning;

@end
