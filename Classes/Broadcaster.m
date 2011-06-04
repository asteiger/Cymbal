#import "Broadcaster.h"
#import "JSONKit.h"
#import "NSNetService+TXTRecord.h"

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
    
    NSString *theData = [sender stringFromTXTRecordForKey:@"packetData"];
    NSLog(@"TXT record update by %@. contents: %@", [service name], theData);
    
    
}

- (MCSongData*)currentSong {
    return [pastSongQueue objectAtIndex:0];
}

- (void)dealloc
{
    [service release];
    service = nil;
    
    [super dealloc];
}

@end
