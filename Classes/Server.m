#import "Server.h"
#import "Packet.h"
#import "Connection.h"
#import "AsyncSocket.h"

@implementation Server

@synthesize connections;
@synthesize isRunning;

- (id)init {
	if ((self = [super init])) {
		serverSocket = [[AsyncSocket alloc] initWithDelegate:self];
		connections = [[NSMutableArray alloc] initWithCapacity:1];
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

	netService = [[NSNetService alloc] initWithDomain:@"" type:@"_metacastapp._tcp." name:@"" port:[serverSocket localPort]];
	[netService scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
	[netService setDelegate:self];
	[netService publish];
    
    return isRunning = YES;
}

- (void)stop {
	[netService stop];
	[netService removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
	[netService release];
	netService = nil;
	
	[serverSocket disconnect];
	
    [connections makeObjectsPerformSelector:@selector(disconnect)];
    [connections removeAllObjects];
	 
    isRunning = NO;
}

- (void)broadcastPacket:(Packet*)packet {
	NSLog(@"Broadcast packet, message type: %@", [packet toJson]);
	
	[connections makeObjectsPerformSelector:@selector(sendPacket:) withObject:packet];
}

- (BOOL)isRunning {
	return isRunning;
}

- (void)dealloc {
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
    [connections addObject:[[[Connection alloc] initWithAsyncSocket:newSocket] autorelease]];
}

#pragma mark -
#pragma mark NSNetService Delegate Methods

- (void)netServiceWillPublish:(NSNetService *)sender { }
- (void)netServiceDidPublish:(NSNetService *)sender {
	NSLog(@"NetService published");
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
