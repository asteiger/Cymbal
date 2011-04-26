#import "Browser.h"

NSString *const kAvailableServiceAddedNotification = @"AvailableServiceAddedNotification";
NSString *const kAvailableServiceRemovedNotification = @"AvailableServiceRemovedNotification";

@implementation Browser

@synthesize services;
@synthesize localName;

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
    
    self.localName = nil;
	
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
    if ([[aNetService name] isEqualToString:[APP_DELEGATE.server name]]) return;
    
    [services addObject:aNetService];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kAvailableServiceAddedNotification object:aNetService userInfo:nil];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didRemoveDomain:(NSString *)domainString moreComing:(BOOL)moreComing {
	
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didRemoveService:(NSNetService *)aNetService moreComing:(BOOL)moreComing {
    NSLog(@"Service disappeared: %@", [aNetService name]);
    if (![services containsObject:aNetService]) return;
	[services removeObject:aNetService];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kAvailableServiceRemovedNotification object:aNetService userInfo:nil];
}

@end
