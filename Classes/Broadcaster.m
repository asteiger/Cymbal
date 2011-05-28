
#import "Broadcaster.h"


@implementation Broadcaster

+ (Broadcaster*)broadcasterWithNetService:(NSNetService *)aNetService {
    return [[[self alloc] initWithNetService:aNetService] autorelease];
}

- (id)initWithNetService:(NSNetService*)aService {
    if ((self = [super init])) {
        service = [aService retain];
        [service setDelegate:self];
        [service startMonitoring];
        
        NSLog(@"broadcaster created with name %@", [service name]);
    }
    
    return self;
}

- (void)netService:(NSNetService *)sender didUpdateTXTRecordData:(NSData *)data {
    NSDictionary *txtRecord = [NSNetService dictionaryFromTXTRecordData:data];
    
    NSString *theData = [[[NSString alloc] initWithData:[txtRecord objectForKey:@"packetData"] encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"TXT record update by %@. contents: %@", [service name], theData);
}

- (void)dealloc
{
    [service release];
    service = nil;
    
    [super dealloc];
}

@end
