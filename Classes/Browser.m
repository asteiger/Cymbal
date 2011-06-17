#import "Browser.h"
#import "Broadcaster.h"

NSString *const kAvailableBroadcasterAddedNotification = @"AvailableServiceAddedNotification";
NSString *const kAvailableBroadcasterRemovedNotification = @"AvailableServiceRemovedNotification";

@implementation Browser

@synthesize services;

- (id)init {
	if ((self = [super init])) {        
		browser = [[NSNetServiceBrowser alloc] init];
		[browser setDelegate:self];
		
		services = [[NSMutableArray alloc] initWithCapacity:1];
		broadcasters = [[NSMutableArray alloc] initWithCapacity:1];
	}
	
	return self;
}

- (void)startBrowsing {
	[browser searchForServicesOfType:kCymbalNetServiceTypeName inDomain:@""];
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
    
    [broadcasters release];
    broadcasters = nil;
	
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
    NSLog(@"Service discovered: %@, my server name is: %@", [aNetService name], [APP_DELEGATE.server name]);
    if ([[aNetService name] isEqualToString:[APP_DELEGATE.server name]]) return;
    
    Broadcaster *broadcaster = [Broadcaster broadcasterWithNetService:aNetService];
    [broadcasters addObject:broadcaster];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kAvailableBroadcasterAddedNotification object:broadcaster userInfo:nil];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didRemoveDomain:(NSString *)domainString moreComing:(BOOL)moreComing {
	
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didRemoveService:(NSNetService *)aNetService moreComing:(BOOL)moreComing {
    NSString *serviceName = [aNetService name];
    Broadcaster *broadcaster = [self availableBroadcasterWithName:serviceName];
    
    NSLog(@"Service disappeared: %@", serviceName);
    
    if (nil == broadcaster) return;

    [broadcasters removeObject:broadcaster];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kAvailableBroadcasterRemovedNotification object:broadcaster userInfo:nil];
}

- (Broadcaster*)availableBroadcasterWithName:(NSString*)name {
    for (Broadcaster* b in broadcasters) {
        
        if ([[b name] isEqualToString:name]) 
            return [[b retain] autorelease];
        
    }
    
    return nil;
}

@end
