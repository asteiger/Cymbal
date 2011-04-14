#import "LocalMediaInfoSupplier.h"
#import "SongDataPacket.h"
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
    
    if (self.mediaState != kMediaStateIdle)
        [_server broadcastPacket:[SongDataPacket packetWithSongData:self.currentSongData]];
}

- (void)updateMediaProperties {
    self.mediaState = [self mediaStateWithPlayerState:[_iTunes playerState] ServerIsRunning:_server.isRunning];
	
    if (self.mediaState == kMediaStateIdle) {
        self.currentSongData = nil;
        
    } else {
        iTunesTrack *currentTrack = [_iTunes currentTrack];
        self.currentSongData = [MCSongData songDataWithArtist:[currentTrack artist] 
                                                    SongTitle:[currentTrack name]
                                                        Album:[currentTrack album]
                                ];
    }
    
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
