#import "Broadcaster.h"
#import "JSONKit.h"
#import "NSNetService+TXTRecord.h"
#import "Server.h"

NSString *const kBrodcasterTXTRecordUpdateNotification = @"BroadcasterUpdatedTXTRecord";

@implementation Broadcaster

@synthesize songData;

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
    
    NSString *json = [sender stringFromTXTRecordForKey:kBroadcasterInfoKey];
    NSLog(@"TXT record update by %@. contents: %@", [service name], json);
    
    self.songData = [[TXTRecordPacket packetWithJson:json] songData];
    [[NSNotificationCenter defaultCenter] postNotificationName:kBrodcasterTXTRecordUpdateNotification object:self];
}

- (NSString*)name {
    return [service name];
}

- (void)dealloc
{
    [service stopMonitoring];
    [service release];
    service = nil;
    
    [super dealloc];
}

@end
