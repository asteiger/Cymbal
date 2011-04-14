#import "MediaController.h"
#import "MCSongData.h"
#import "iTunes.h"

@interface LocalMediaController : MediaController {
    iTunesApplication *iTunes;
	NSString *playerState;
    MCSongData *currentSongData;
}

- (void)receivedItunesNotification:(NSNotification *)mediaNotification;

@end
