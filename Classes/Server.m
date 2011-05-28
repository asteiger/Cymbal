#import "Server.h"
#import "Packet.h"
#import "NotificationController.h"

@implementation Server

@synthesize name;
@synthesize isRunning;

- (id)init {
	if ((self = [super init])) {
        name = [[[NSHost currentHost] localizedName] retain];
        self.isRunning = NO;
	}
	
	return self;
}

- (BOOL)start {
	netService = [[NSNetService alloc] initWithDomain:@"" type:kCymbalNetServiceTypeName name:@"" port:42681];
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
	 
    self.isRunning = NO;
    
    [[NotificationController sharedInstance] postBroadcastStoppedNotification];
    NSLog(@"Server stopped");
}

- (void)broadcastPacket:(Packet*)packet {
    if (!self.isRunning) return;
    
	NSLog(@"Broadcast packet, message: %@", [packet toJson]);
    
    NSDictionary *txtRecord = [NSDictionary dictionaryWithObject:[[packet toJson] dataUsingEncoding:NSUTF8StringEncoding] forKey:@"packetData"];
    BOOL success = [netService setTXTRecordData:[NSNetService dataFromTXTRecordDictionary:txtRecord]];
    NSLog(@"txtrecord success: %d", success);
}

- (void)dealloc {
    [name release];
    name = nil;
	
	[super dealloc];
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
