#import "LocalMediaInfoSupplier.h"
#import "SongDataPacket.h"
#import "MCSongData.h"
#import "MCGrowlController.h"

@interface LocalMediaInfoSupplier (Private)
- (NSString*)mediaStateWithPlayerState:(iTunesEPlS)iTunesPlayerState ServerIsRunning:(BOOL)isRunning;
@end

@implementation LocalMediaInfoSupplier

- (id)initWithServer:(Server*)server {
	if ((self = [super init])) {
        _server = [server retain];
        _iTunes = [[SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"] retain];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(broadcastCurrentSongData) name:kListenerConnectedNotification object:nil];
		[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedItunesNotification:) name:@"com.apple.iTunes.playerInfo" object:nil];
		NSLog(@"Registered iTunes listener");
        
        [self updateMediaProperties];
        
	}
	
	return self;
}

- (void)broadcastCurrentSongData {
    [_server broadcastPacket:[SongDataPacket packetWithSongData:self.currentSongData]];
}

- (void)receivedItunesNotification:(NSNotification *)mediaNotification {
	NSLog(@"Got iTunes notification");
    
	[self updateMediaProperties];
    
    if (self.mediaState != kMediaStateIdle) {
        [self broadcastCurrentSongData];
        [MCGrowlController postNotificationWithSong:self.currentSongData];
    }
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
    NSLog(@"dealloc localmediainfosupplier");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
    
    [_iTunes release];
    [_server release];
    
	[super dealloc];
}

- (NSString*)mediaStateWithPlayerState:(iTunesEPlS)iTunesPlayerState ServerIsRunning:(BOOL)isRunning {
    if (iTunesPlayerState != iTunesEPlSStopped && iTunesPlayerState != iTunesEPlSPaused) 
        return isRunning ? kMediaStateBroadcasting : kMediaStatePlaying;
    
    return kMediaStateIdle;
}

@end
