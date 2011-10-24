#import "Spotify.h"

@interface SpotifyPoller : NSObject {
    BOOL _pollEnabled;
    SpotifyApplication *_spotify;
    
    SpotifyEPlS _playerState;
    NSString *_currentTrackUrl;
}

@end
