//
//  Server.m
//  Djinn
//
//  Created by Ashley Steigerwalt on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Server.h"


@implementation Server

- (id)init {
	if (self = [super init]) {
		serverSocket = [[AsyncSocket alloc] initWithDelegate:self];
		connectedSockets = [[NSMutableArray alloc] initWithCapacity:1];
	}
	
	return self;
}

- (void)start {
	NSError *error = nil;
	if(![serverSocket acceptOnPort:0 error:&error])
	{
		NSLog(@"Error starting server: %@", error);
		return;
	}
	
	NSLog(@"Server started on port %hu", [serverSocket localPort]);
}

- (void)stop {
	[serverSocket disconnect];
	
	for(int i = 0; i < [connectedSockets count]; i++) {
		[[connectedSockets objectAtIndex:i] disconnect];
	}
}

- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket {
	[connectedSockets addObject:newSocket];
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
	NSLog(@"Accepted client %@:%hu", host, port);
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
	[sock readDataToData:[AsyncSocket CRLFData] withTimeout:-1 tag:0];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
	// ignore data received
	// we are only interested in sending
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
	NSLog(@"Client Disconnected: %@:%hu", [sock connectedHost], [sock connectedPort]);
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
	[connectedSockets removeObject:sock];
}

- (void)broadcastSongData:(MCSongData*)songData {
	for (int i = 0; i < [connectedSockets count]; i++) {
		AsyncSocket *client = [connectedSockets objectAtIndex:i];
		[client writeData:[@"hello\r\n" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
	}
}

@end
