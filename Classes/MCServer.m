//
//  MCServer.m
//  Djinn
//
//  Created by Ashley Steigerwalt on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MCServer.h"
#import "MCStatusMenu.h"
#import "MCMetacaster.h"

@implementation MCServer

static MCServer *sharedInstance = nil;
+ (MCServer*)sharedMCServer {
	if (sharedInstance == nil) {
		sharedInstance = [[MCServer alloc] init];
	}
	
	return sharedInstance;
}

- (id)init {
	if (self = [super init]) {
		metacasters = [[NSMutableArray alloc] init];
		
		server = [[Server alloc] initWithProtocol:@"metacast"];
		server.delegate = self;
	}
	
	return self;
}

- (void)startMetacasting {
	NSError *error = nil;
	if (![server start:&error]) {
		NSLog(@"Error: %@", error);
		return;
	}
	
	[[MCStatusMenu sharedMCStatusMenu] updateAppStatus:kMetacasting];
}

- (void)stopMetacasting {
	[server stop];
	[[MCStatusMenu sharedMCStatusMenu] updateAppStatus:kIdle];
}

- (void)connectToMetacaster:(MCMetacaster*)metacaster {
	[server connectToRemoteService:metacaster.service];
}


	 
- (void)serverRemoteConnectionComplete:(Server *)server {
	NSLog(@"Connected");
}

- (void)serverStopped:(Server *)server {
	NSLog(@"Server stopped");
	[[MCStatusMenu sharedMCStatusMenu] updateAppStatus:kIdle];
}

- (void)server:(Server *)server didNotStart:(NSDictionary *)errorDict {
	NSLog(@"Start failed.");
}

- (void)server:(Server *)server didAcceptData:(NSData *)data {
	NSLog(@"Got data: %@", [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
	[[MCStatusMenu sharedMCStatusMenu] updateAppStatus:kMetacasting];
}

- (void)server:(Server *)server lostConnection:(NSDictionary *)errorDict {
	NSLog(@"Lost connection");
}

- (void)serviceAdded:(NSNetService *)service moreComing:(BOOL)more {
	NSLog(@"Service added");
	MCMetacaster *metacaster = [[[MCMetacaster alloc] initWithService:service] autorelease];
	
	[metacasters addObject:metacaster];
	[[MCStatusMenu sharedMCStatusMenu] addMetacaster:metacaster];
}

- (void)serviceRemoved:(NSNetService *)service moreComing:(BOOL)more {
	NSLog(@"Service removed");	
}


-(void)dealloc {
	[server stop];
    [server release]; server = nil;
	[metacasters release]; metacasters = nil;
	
    [super dealloc];
}



@end
