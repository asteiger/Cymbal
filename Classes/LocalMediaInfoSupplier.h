#import "MediaInfoSupplier.h"
#import "MCSongData.h"
#import "iTunes.h"
#import "Server.h"

@interface LocalMediaInfoSupplier : MediaInfoSupplier {
    Server *_server;
    iTunesApplication *_iTunes;

}

- (id)initWithServer:(Server*)server;
- (void)receivedItunesNotification:(NSNotification *)mediaNotification;
- (void)broadcastCurrentSongData;

@end
