#import "Browser.h"
#import "MCBroadcaster.h"

@implementation Browser

@synthesize services;

- (id)init {
	if ((self = [super init])) {
		browser = [[NSNetServiceBrowser alloc] init];
		[browser setDelegate:self];
		
		services = [[NSMutableArray alloc] initWithCapacity:1];
	}
	
	return self;
}

- (void)startBrowsing {
	[browser searchForServicesOfType:@"_metacastapp._tcp." inDomain:@""];
}

- (void)stopBrowsing {
	[browser stop];
}

- (void)dealloc {
	[self stopBrowsing];
	
	[browser dealloc];
	browser = nil;
	
	[services dealloc];
	services = nil;
	
	[super dealloc];
}

#pragma mark Service Browser Delegate Methods

- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)aNetServiceBrowser {
	
}

- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)aNetServiceBrowser {
	
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didNotSearch:(NSDictionary *)errorDict {
	
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindDomain:(NSString *)domainString moreComing:(BOOL)moreComing {
	
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing {
    [services addObject:aNetService];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didRemoveDomain:(NSString *)domainString moreComing:(BOOL)moreComing {
	
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didRemoveService:(NSNetService *)aNetService moreComing:(BOOL)moreComing {
	[services removeObject:aNetService];
}

@end
