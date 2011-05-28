#import "LocalMediaInfoSupplier.h"
#import "SongDataPacket.h"
#import "MCSongData.h"
#import "NotificationController.h"
#import "Connection.h"
#import "PreferencesController.h"

@interface LocalMediaInfoSupplier (Private)
- (NSString*)mediaStateWithPlayerState:(iTunesEPlS)iTunesPlayerState ServerIsRunning:(BOOL)isRunning;
@end

@implementation LocalMediaInfoSupplier

- (id)initWithServer:(Server*)server {
	if ((self = [super init])) {
        _server = [server retain];
        _iTunes = [[SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"] retain];
        
		[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedItunesNotification:) name:@"com.apple.iTunes.playerInfo" object:nil];
		NSLog(@"Registered iTunes listener");
        
        [self updateMediaProperties];
        
	}
	
	return self;
}

- (void)broadcastCurrentSongData {
    if (self.currentSongData == nil) return;
    
    [_server broadcastPacket:[SongDataPacket packetWithSongData:self.currentSongData]];
}

- (void)receivedItunesNotification:(NSNotification *)mediaNotification {
	NSLog(@"Got iTunes notification");
    
	[self updateMediaProperties];
    
    if (self.mediaState != kMediaStateIdle) {
        if ([PreferencesController sharedInstance].allowBroadcasting && !_server.isRunning) {
            [_server start];
            self.mediaState = kMediaStateBroadcasting;
        }
        
        [self broadcastCurrentSongData];
        [[NotificationController sharedInstance] postNotificationWithSong:self.currentSongData];
    } else {
        if (_server.isRunning) [_server stop];
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
