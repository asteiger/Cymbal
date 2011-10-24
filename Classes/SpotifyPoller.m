#import "SpotifyPoller.h"

@interface SpotifyPoller (Private)

- (void)poll;
    
@end

@implementation SpotifyPoller

- (id)init {
    if ((self = [super init])) {
        _spotify = [[SBApplication applicationWithBundleIdentifier:kSpotifyBundleIdentifier] retain];
        _pollEnabled = YES;
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self poll];
        });
    }
    
    return self;
}

- (void)poll {
    if (!_pollEnabled) return;
    
    if (_spotify.playerState != _playerState || (_currentTrackUrl != nil && ![_currentTrackUrl isEqualToString:_spotify.currentTrack.spotifyUrl])) {
        _playerState = _spotify.playerState;
        
        if (nil != _currentTrackUrl) [_currentTrackUrl release];
        _currentTrackUrl = [_spotify.currentTrack.spotifyUrl copy];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SpotifyPlayerStateChanged" object:nil];
        NSLog(@"%d, %@", _playerState, _currentTrackUrl);
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self poll];
    });
}

- (void)dealloc {
    _pollEnabled = NO;
    
    [_spotify release];
    if (nil != _currentTrackUrl) [_currentTrackUrl release];
    
    [super dealloc];
}

@end
