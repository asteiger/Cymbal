#import "LocalMediaInfoSupplier.h"
#import "BroadcasterInfo.h"
#import "MCSongData.h"
#import "NotificationController.h"
#import "PreferencesController.h"

NSString *const iTunesBundleIdentifier = @"com.apple.iTunes";

@interface LocalMediaInfoSupplier (Private)
- (NSString*)mediaStateWithPlayerState:(iTunesEPlS)iTunesPlayerState ServerIsRunning:(BOOL)isRunning;
@end

@implementation LocalMediaInfoSupplier

- (id)initWithServer:(Server*)server {
	if ((self = [super init])) {
        _server = [server retain];
        
        
		[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedItunesNotification:) name:@"com.apple.iTunes.playerInfo" object:nil];
		NSLog(@"Registered iTunes listener");
        
        [self updateMediaProperties];
        
	}
	
	return self;
}

- (void)broadcastCurrentSongData {
    
}

- (void)receivedItunesNotification:(NSNotification *)mediaNotification {
	NSLog(@"Got iTunes notification");
    
	[self updateMediaProperties];
    
    if (self.mediaState != kMediaStateIdle) {
        if ([PreferencesController sharedInstance].allowBroadcasting && !_server.isRunning) {
            [_server start];
            self.mediaState = kMediaStateBroadcasting;
        }
        
        if (self.currentSongData != nil) {
        
            TXTRecordPacket *packet = [[[TXTRecordPacket alloc] init] autorelease];
            [packet setSongData:self.currentSongData];
            
            [_server setTXTRecord:packet];
            
            [[NotificationController sharedInstance] postNotificationWithSong:self.currentSongData];
        }
        
    } else {
        if (_server.isRunning) [_server stop];
    }
}

- (void)updateMediaProperties {
    self.mediaState = kMediaStateIdle;
    self.currentSongData = nil;
    if (![self iTunesIsRunning]) return;
    
    if (_iTunes == nil) _iTunes = [[SBApplication applicationWithBundleIdentifier:iTunesBundleIdentifier] retain];
    
    self.mediaState = [self mediaStateWithPlayerState:[_iTunes playerState] ServerIsRunning:_server.isRunning];

    if (self.mediaState != kMediaStateIdle) {
        iTunesTrack *currentTrack = [_iTunes currentTrack];
        self.currentSongData = [MCSongData songDataWithArtist:[currentTrack artist] 
                                                    SongTitle:[currentTrack name]
                                                        Album:[currentTrack album]
                                ];
    }
    
}

- (BOOL)iTunesIsRunning {
    NSArray *apps = [NSRunningApplication runningApplicationsWithBundleIdentifier:iTunesBundleIdentifier];
    return [apps count] > 0;
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
    if (iTunesPlayerState != 0 && iTunesPlayerState != iTunesEPlSStopped && iTunesPlayerState != iTunesEPlSPaused) 
        return isRunning ? kMediaStateBroadcasting : kMediaStatePlaying;
    
    return kMediaStateIdle;
}

@end
