#import "RdioPoller.h"

@interface RdioPoller (Private)

- (void)poll;

@end

@implementation RdioPoller

- (id)init {
    if ((self = [super init])) {
        _rdio = [[SBApplication applicationWithBundleIdentifier:kRdioBundleIdentifier] retain];
        _pollingEnabled = YES;
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self poll];
        });
    }
    
    return self;
}

- (void)poll {
    if (!_pollingEnabled) return;
    
    if (_playerState != _rdio.playerState || (_currentTrackUrl != nil && ![_currentTrackUrl isEqualToString:_rdio.currentTrack.rdioUrl])) {
        _playerState = _rdio.playerState;

        if (nil != _currentTrackUrl) [_currentTrackUrl release];
        _currentTrackUrl = [_rdio.currentTrack.rdioUrl copy];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RdioPlayerStateChanged" object:nil];
        NSLog(@"%i, %@", _playerState, _currentTrackUrl);
    } 
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self poll];
    });
}

- (void)dealloc {
    _pollingEnabled = NO;
    [_rdio release];
    
    [super dealloc];
}

@end
