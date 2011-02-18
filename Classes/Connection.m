//
//  Connection.m
//  Djinn
//
//  Created by Ashley Steigerwalt on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Connection.h"
#import "MCGrowlController.h"

@implementation Connection

- (id)initWithNetService:(NSNetService *)aNetService ShouldConnect:(BOOL)shouldConnect {
	if (self = [super init]) {
		netService = [aNetService retain];
		socket = [[AsyncSocket alloc] init];
		
		if (shouldConnect) [self connect];
	}
	
	return self;
}

- (void)connect {
	NSError *error;
	if (![socket connectToHost:[netService hostName] onPort:[netService port] withTimeout:-1 error:&error]) {
		NSLog([error localizedDescription], nil);
	}
}

- (void)disconnect {
	[socket disconnect];
}

- (BOOL)isConnected {
	return [socket isConnected];
}

- (void)dealloc {
	[netService release];
	netService = nil;
	
	[socket disconnect];
	[socket release];
	socket = nil;
	
	[super dealloc];
}

#pragma mark AsyncSocket Delegate Methods

- (void)onSocketDidDisconnect:(AsyncSocket *)sock {

}

- (BOOL)onSocketWillConnect:(AsyncSocket *)sock {
	return YES;
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
	[MCGrowlController postConnectedToBroadcasterWithName:[netService name]];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
	// post growl notification
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag {
	
}


@end
