#import "MediaInfoSupplier.h"
#import "MCSongData.h"
#import "iTunes.h"
#import "Server.h"
#import "Spotify.h"

@interface LocalMediaInfoSupplier : MediaInfoSupplier {
    Server *_server;
    iTunesApplication *_iTunes;
    SpotifyApplication *_spotify;
}

- (id)initWithServer:(Server*)server;
- (void)receivedMediaNotification:(NSNotification *)mediaNotification;
- (BOOL)iTunesIsRunning;

@end
