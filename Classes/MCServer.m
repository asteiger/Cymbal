//
//  MCServer.m
//  MetaCast
//
//  Created by Ashley Steigerwalt on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MCServer.h"
#import "MCStatusMenu.h"

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
		server = [[Server alloc] initWithDomainName:@"" protocol:@"_metacast._tcp." name:@""];
		server.delegate = self;
	}
	
	return self;
}

-(void)startMetacasting {
	NSError **error;
	if ([server start:error]) {
		[[MCStatusMenu sharedMCStatusMenu] updateAppStatus:NSLocalizedString(@"Metacasting", NULL)];
	}
}

-(void)stopMetacasting {
	[server stop];
	[[MCStatusMenu sharedMCStatusMenu] updateAppStatus:NSLocalizedString(@"Idle.", NULL)];
}
	 
- (void)serverRemoteConnectionComplete:(Server *)server {
	
}

- (void)serverStopped:(Server *)server {
	
}

- (void)server:(Server *)server didNotStart:(NSDictionary *)errorDict {
	
}

- (void)server:(Server *)server didAcceptData:(NSData *)data {
	
}

- (void)server:(Server *)server lostConnection:(NSDictionary *)errorDict {
	
}

- (void)serviceAdded:(NSNetService *)service moreComing:(BOOL)more {
	
}

- (void)serviceRemoved:(NSNetService *)service moreComing:(BOOL)more {
	
}


-(void)dealloc {
	[server stop];
    [server release]; server = nil;
	
    [super dealloc];
}



@end
