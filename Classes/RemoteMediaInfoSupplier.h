#import "MediaInfoSupplier.h"
#import "Broadcaster.h"

@interface RemoteMediaInfoSupplier : MediaInfoSupplier {
    Broadcaster *broadcaster;
}

@property (nonatomic, retain) Broadcaster *broadcaster;

- (id)initWithBroadcaster:(Broadcaster*)aBroadcaster;
- (void)broadcaterInfoUpdated;

@end
