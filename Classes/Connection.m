#import "Connection.h"
#import "Server.h"
#import "Packet.h"
#import "GrowlNotifier.h"

NSString const* kPacketReceivedNotification = @"PacketReceivedNotification";

@interface Connection (Private) 

- (id)initWithLocalName:(NSString*)name;
- (void)receivedPacketNotification:(NSNotification*)notification;

@end

@implementation Connection

@synthesize localName;
@synthesize remoteName;

- (id)initWithLocalName:(NSString*)name {
    if ((self = [super init])) {
        self.localName = name;
        self.remoteName = @"Remote Name Unavailable";
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(receivedPacketNotification:) 
                                                     name:(NSString*)kPacketReceivedNotification 
                                                   object:self];
    }
        
    return self;
}

#pragma mark -
#pragma mark Connection to Listener

- (id)initWithAsyncSocket:(AsyncSocket*)aSocket LocalName:(NSString*)name {
	if ((self = [self initWithLocalName:name])) {
		socket = [aSocket retain];
		
        [socket setDelegate:self];
        [socket readDataWithTimeout:-1 tag:0];
        
        NSLog(@"made connection jammy");
	}
	
	return self;
}

- (void)didReceiveConnectionInfoPacket:(ConnectionInfoPacket*)packet {
    NSLog(@"Recieved connection info");
    self.remoteName = nil;
	self.remoteName = [packet clientName];
    NSLog(@"Connection set remote name to %@", self.remoteName);
}

#pragma mark -
#pragma mark Connection to Server

- (id)initWithNetService:(NSNetService *)aNetService LocalName:(NSString*)name {
	if ((self = [self initWithLocalName:name])) {

		[aNetService setDelegate:self];
		
		socket = [[AsyncSocket alloc] init];
		[socket setDelegate:self];
		
		[aNetService resolveWithTimeout:-1];
	}
	
	return self;
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender {
	NSLog(@"Netservice resolved address");
	
	NSError *error;
	
	if (![socket connectToHost:[sender hostName] onPort:[sender port] withTimeout:-1 error:&error]) {
		NSLog([error localizedDescription], nil);
	}
	
    [sender stop];
    
	[socket readDataWithTimeout:-1 tag:0];
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict {
	NSLog(@"Netservice failed to resolve");
}

#pragma mark -
#pragma mark AsyncSocket Delegate Methods

- (BOOL)onSocketWillConnect:(AsyncSocket *)sock {
    NSLog(@"Connection will connect");
	return YES;
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
	NSLog(@"Connection didConnectToHost: %@", host);
    self.remoteName = [NSString stringWithFormat:@"Resolving... (%@)", [sock connectedHost]];
    [self sendPacket:[[ConnectionInfoPacket alloc] initWithName:self.localName]];
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err {
	NSLog(@"Connection Disconnect");
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock {
    NSLog(@"Connection disconnected");
    [socket release];
	socket = nil;
    
    self.remoteName = nil;
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
	NSLog(@"Connection read data");
	
	NSString *json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	Packet *p = [Packet packetWithJson:json];
	
    [[NSNotificationCenter defaultCenter] postNotificationName:(NSString*)kPacketReceivedNotification object:self userInfo:[p toDictionary]];
    
	[socket readDataWithTimeout:-1 tag:0];
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag {
	NSLog(@"Connection wrote data");
}

#pragma mark -
#pragma mark Instance Methods

- (void)disconnect {
	[socket disconnect];
}

- (BOOL)isConnected {
	return [socket isConnected];
}

- (void)sendPacket:(Packet*)packet {
	NSData *data = [[packet toJson] dataUsingEncoding:NSUTF8StringEncoding];
	[socket writeData:data withTimeout:-1 tag:0];
}

- (void)dealloc {	
	[socket disconnect];
	[socket release];
	socket = nil;
    
    self.localName = nil;
    self.remoteName = nil;
	
	[super dealloc];
}

#pragma mark -
#pragma mark Events

- (void)receivedPacketNotification:(NSNotification*)notification {
    NSLog(@"Packet Notification");
    id p = [Packet packetWithDictionary:[notification userInfo]];
    
    if ([p isKindOfClass:[ConnectionInfoPacket class]]) {
        [self didReceiveConnectionInfoPacket:(ConnectionInfoPacket*)p];
        
    }
}

@end
