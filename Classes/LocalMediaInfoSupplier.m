#import "LocalMediaInfoSupplier.h"
#import "MCSongData.h"

@interface LocalMediaInfoSupplier (Private)
- (NSString*)mediaStateWithPlayerState:(iTunesEPlS)iTunesPlayerState ServerIsRunning:(BOOL)isRunning;
@end

@implementation LocalMediaInfoSupplier

- (id)initWithServer:(Server*)server {
	if ((self = [super init])) {
        _server = [server retain];
        _iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
        
		[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedItunesNotification:) name:@"com.apple.iTunes.playerInfo" object:nil];
		NSLog(@"Registered iTunes listener");
        
        [self updateMediaProperties];
        
	}
	
	return self;
}

- (void)receivedItunesNotification:(NSNotification *)mediaNotification {
	NSLog(@"Got iTunes notification");
	[self updateMediaProperties];
}

- (void)updateMediaProperties {
    iTunesEPlS playerState = [_iTunes playerState];
    
    self.mediaState = [self mediaStateWithPlayerState:playerState ServerIsRunning:_server.isRunning];
	
    if (playerState == iTunesEPlSStopped || playerState == iTunesEPlSPaused) {
        NSLog(@"Updated media properties. Media State: %@. Current Song: nil", self.mediaState);
        self.currentSongData = nil;
        return;
    }
    
	self.currentSongData = [MCSongData songDataWithArtist:[[_iTunes currentTrack] artist]
                                                SongTitle:[[_iTunes currentTrack] name]
                                                    Album:[[_iTunes currentTrack] album]
                            ];
    NSLog(@"Updated media properties. Media State: %@. Current Song: %@", self.mediaState, self.currentSongData.songTitle);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.mediaState = nil;
    [_server release];
    
	[super dealloc];
}

- (NSString*)mediaStateWithPlayerState:(iTunesEPlS)iTunesPlayerState ServerIsRunning:(BOOL)isRunning {
    if (iTunesPlayerState != iTunesEPlSStopped && iTunesPlayerState != iTunesEPlSPaused) 
        return isRunning ? kMediaStateBroadcasting : kMediaStatePlaying;
    
    return kMediaStateIdle;
}

@end
