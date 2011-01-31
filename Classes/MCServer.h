//
//  MCServer.h
//  Djinn
//
//  Created by Ashley Steigerwalt on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Server.h"
#import "MCMetacaster.h"


@interface MCServer : NSObject <ServerDelegate> {
	Server *server;
	NSMutableArray *metacasters;
}

+ (MCServer*)sharedMCServer;

- (void)startMetacasting;
- (void)stopMetacasting;
- (void)connectToMetacaster:(MCMetacaster*)metacaster;

@end
