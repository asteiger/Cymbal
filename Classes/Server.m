#import "Server.h"
#import "TXTRecordPacket.h"
#import "NotificationController.h"

NSString *const kBroadcasterInfoKey = @"BroadcasterInfo";

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
    [APP_DELEGATE trackEventWithName:@"Server" value:@"Started"];
    
    self.isRunning = YES;
    
	netService = [[NSNetService alloc] initWithDomain:@"" type:kCymbalNetServiceTypeName name:@"" port:42681];
	[netService scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
	[netService setDelegate:self];
    
    TXTRecordPacket *txtRecord = [[[TXTRecordPacket alloc] init] autorelease];
    [txtRecord setSongData:APP_DELEGATE.mediaInfoSupplier.currentSongData];
    
    [self setTXTRecord:txtRecord];
    
	[netService publish];
    
    [[NotificationController sharedInstance] postBroadcastStartedNotification];
    return self.isRunning;
}

- (void)stop {
    if (!self.isRunning) return;
    
    [APP_DELEGATE trackEventWithName:@"Server" value:@"Stopped"];
    
	[netService stop];
	[netService removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
	[netService release];
	netService = nil;
	 
    self.isRunning = NO;
    
    [[NotificationController sharedInstance] postBroadcastStoppedNotification];
    NSLog(@"Server stopped");
}

- (void)setTXTRecord:(TXTRecordPacket*)info {
    if (!self.isRunning) return;
    
    NSLog(@"Setting TXT record");
    NSDictionary *txtRecord = [NSDictionary dictionaryWithObject:[[info toJson] dataUsingEncoding:NSUTF8StringEncoding] forKey:kBroadcasterInfoKey];
    [netService setTXTRecordData:[NSNetService dataFromTXTRecordDictionary:txtRecord]];
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
