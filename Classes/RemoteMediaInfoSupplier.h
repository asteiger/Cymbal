#import "MediaInfoSupplier.h"
#import "Connection.h"

@interface RemoteMediaInfoSupplier : MediaInfoSupplier {
    Connection *_connection;
}

- (id)initWithConnection:(Connection*)connection;

@end
