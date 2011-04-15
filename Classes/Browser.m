#import "Browser.h"
#import "MCBroadcaster.h"

NSString *const kServiceNameKey = @"ServiceName";
NSString *const kAvailableServiceAddedNotification = @"AvailableServiceAddedNotification";
NSString *const kAvailableServiceRemovedNotification = @"AvailableServiceRemovedNotification";

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

- (NSNetService*)serviceWithName:(NSString*)name {
    NSEnumerator *enumerator = [services objectEnumerator];
    NSNetService *service;
    
    while ((service = [enumerator nextObject])) {
        if ([service name] == name) return service;
    }
    
    return nil;
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
    NSLog(@"Service discovered: %@", [aNetService name]);
    [services addObject:aNetService];
    
    NSDictionary *info = [NSDictionary dictionaryWithObject:[aNetService name] forKey:kServiceNameKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:kAvailableServiceAddedNotification object:self userInfo:info];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didRemoveDomain:(NSString *)domainString moreComing:(BOOL)moreComing {
	
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didRemoveService:(NSNetService *)aNetService moreComing:(BOOL)moreComing {
    NSLog(@"Service disappeared: %@", [aNetService name]);
	[services removeObject:aNetService];
    
    NSDictionary *info = [NSDictionary dictionaryWithObject:[aNetService name] forKey:kServiceNameKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:kAvailableServiceRemovedNotification object:self userInfo:info];
}

@end
