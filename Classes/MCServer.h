//
//  MCServer.h
//  MetaCast
//
//  Created by Ashley Steigerwalt on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Server.h"


@interface MCServer : NSObject <ServerDelegate> {
	Server *server;
}

+ (MCServer*)sharedMCServer;

-(void)startMetacasting;
-(void)stopMetacasting;

@end
