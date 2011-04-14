#import "RemoteMediaInfoSupplier.h"


@implementation RemoteMediaInfoSupplier

- (id)initWithConnection:(Connection*)connection {
    if ((self = [super init])) {
        _connection = [connection retain];
        [self updateMediaProperties];
    }
    
    return self;
}

- (void)updateMediaProperties {
    self.mediaState = (NSString*)([_connection isConnected] ? kMediaStateListening : kMediaStateIdle);
}

- (void)dealloc {
    [_connection release];
    [super dealloc];
}

@end
