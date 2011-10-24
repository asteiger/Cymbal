#import "Rdio.h"

@interface RdioPoller : NSObject {
    RdioApplication *_rdio;
    RdioEPSS _playerState;
    NSString *_currentTrackUrl;
    BOOL _pollingEnabled;
}

@end
