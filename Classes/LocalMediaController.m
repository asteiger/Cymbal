#import "LocalMediaController.h"
#import "MCSongData.h"

@interface LocalMediaController (Private)
- (NSString*)playerStateAsStringWithItunesApplication:(iTunesApplication*)iTunesApp;
- (void)updateCurrentMediaProperties;
@end

@implementation LocalMediaController

@synthesize playerState;
@synthesize currentSongData;

#define iTunesStopped @"Stopped"
#define iTunesPaused @"Paused"
#define iTunesPlaying @"Playing"
#define iTunesFastForwarding @"Fast Forwarding"
#define iTunesRewinding @"Rewinding"

- (id)init {
	if ((self = [super init])) {
        iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
        
		[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedItunesNotification:) name:@"com.apple.iTunes.playerInfo" object:nil];
		NSLog(@"Registered iTunes listener");
        
        [self updateCurrentMediaProperties];
        
	}
	
	return self;
}

- (void)receivedItunesNotification:(NSNotification *)mediaNotification {
	NSLog(@"Got iTunes notification");
	
	[self updateCurrentMediaProperties];
}

- (void)updateCurrentMediaProperties {
    self.playerState = [self playerStateAsStringWithItunesApplication:iTunes];
	
    if ([self.playerState isEqualToString:iTunesStopped] || [self.playerState isEqualToString:iTunesPaused]) {
        self.currentSongData = nil;
        return;
    }
    
	self.currentSongData = [MCSongData songDataWithArtist:[[iTunes currentTrack] artist]
                                                SongTitle:[[iTunes currentTrack] name]
                                                    Album:[[iTunes currentTrack] album]
                            ];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.playerState = nil;
    
	[super dealloc];
}

- (NSString*)playerStateAsStringWithItunesApplication:(iTunesApplication*)iTunesApp {
    switch ([iTunesApp playerState]) {
        case iTunesEPlSPlaying:
            return iTunesPlaying;
            break;
            
        case iTunesEPlSPaused:
            return iTunesPaused;
            break;
            
        case iTunesEPlSStopped:
            return iTunesStopped;
            break;
            
        case iTunesEPlSRewinding:
            return iTunesRewinding;
            break;
            
        case iTunesEPlSFastForwarding:
            return iTunesFastForwarding;
            break;
            
        default:
            return nil;
            break;
    }
}

@end
