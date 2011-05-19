#import "Server.h"
#import "Packet.h"
#import "Connection.h"
#import "AsyncSocket.h"
#import "NotificationController.h"

NSString *const kListenerConnectedNotification = @"ListenerConnectedNotification";

@implementation Server

@synthesize name;
@synthesize connections;
@synthesize isRunning;

- (id)init {
	if ((self = [super init])) {
        name = [[[NSHost currentHost] localizedName] retain];
		serverSocket = [[AsyncSocket alloc] initWithDelegate:self];
		connections = [[NSMutableArray alloc] initWithCapacity:1];
        self.isRunning = NO;
	}
	
	return self;
}

- (BOOL)start {
    
	NSError *error = nil;
	if(![serverSocket acceptOnPort:0 error:&error])
	{
		NSLog(@"Error starting server: %@", error);
		return NO;
	}
	
	NSLog(@"Server started on %@ port %hu", [serverSocket localHost], [serverSocket localPort]);

	netService = [[NSNetService alloc] initWithDomain:@"" type:kCymbalNetServiceTypeName name:@"" port:[serverSocket localPort]];
	[netService scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
	[netService setDelegate:self];
	[netService publish];
    
    [[NotificationController sharedInstance] postBroadcastStartedNotification];
    return self.isRunning = YES;
}

- (void)stop {
    if (!self.isRunning) return;
    
	[netService stop];
	[netService removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
	[netService release];
	netService = nil;
	
	[serverSocket disconnect];
	
    [connections makeObjectsPerformSelector:@selector(disconnect)];
    [connections removeAllObjects];
	 
    self.isRunning = NO;
    
    [[NotificationController sharedInstance] postBroadcastStoppedNotification];
    NSLog(@"Server stopped");
}

- (void)broadcastPacket:(Packet*)packet {
    if (!self.isRunning) return;
    
	NSLog(@"Broadcast packet, message: %@", [packet toJson]);
	
	[connections makeObjectsPerformSelector:@selector(sendPacket:) withObject:packet];
}

- (void)dealloc {
    [name release];
    name = nil;
    
	[serverSocket release];
	serverSocket = nil;
	
	[connections release];
	connections = nil;
	
	[super dealloc];
}

#pragma mark -
#pragma mark AsyncSocket Delegate Methods

- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket {
    NSLog(@"Server accepted socket");
    
    Connection *c = [[[Connection alloc] initWithAsyncSocket:newSocket LocalName:self.name] autorelease];
    [connections addObject:c];

    [[NSNotificationCenter defaultCenter] postNotificationName:kListenerConnectedNotification object:c];
}

#pragma mark -
#pragma mark NSNetService Delegate Methods

- (void)netServiceWillPublish:(NSNetService *)sender { }
- (void)netServiceDidPublish:(NSNetService *)sender {
	NSLog(@"NetService published");
    
    [name release];
    name = [[netService name] retain];
    NSLog(@"Set server name to %@", name);
}

- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict {
	NSLog(@"NetService publish failed");
}

- (void)netServiceWillResolve:(NSNetService *)sender { }
- (void)netServiceDidResolveAddress:(NSNetService *)sender {
	NSLog(@"NetService resolved address.");
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict {
	NSLog(@"NetService resolve failed");
}

- (void)netServiceDidStop:(NSNetService *)sender {
	NSLog(@"NetService stopped.");
}

- (void)netService:(NSNetService *)sender didUpdateTXTRecordData:(NSData *)data { }


@end
