#import "MediaInfoSupplier.h"
#import "MCSongData.h"
#import "iTunes.h"
#import "Server.h"
#import "Spotify.h"
#import "Rdio.h"

@interface LocalMediaInfoSupplier : MediaInfoSupplier {
    Server *_server;
    iTunesApplication *_iTunes;
    SpotifyApplication *_spotify;
    RdioApplication *_rdio;
}

- (id)initWithServer:(Server*)server;
- (void)receivedMediaNotification:(NSNotification *)mediaNotification;
- (BOOL)applicationIsRunning:(NSString*)bundleIdentifer;

@end
