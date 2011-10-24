#import "LocalMediaInfoSupplier.h"
#import "TXTRecordPacket.h"
#import "MCSongData.h"
#import "NotificationController.h"
#import "PreferencesController.h"

NSString *const iTunesBundleIdentifier = @"com.apple.iTunes";

@interface LocalMediaInfoSupplier (Private)
- (NSString*)mediaStateWithPlayerState:(iTunesEPlS)iTunesPlayerState ServerIsRunning:(BOOL)isRunning;
- (NSString*)spotifyMediaStateWithPlayerState:(SpotifyEPlS)iTunesPlayerState ServerIsRunning:(BOOL)isRunning;
@end

@implementation LocalMediaInfoSupplier

- (id)initWithServer:(Server*)server {
	if ((self = [super init])) {
        _server = [server retain];
        
        
		[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedMediaNotification:) name:@"com.apple.iTunes.playerInfo" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedMediaNotification:) name:@"SpotifyPlayerStateChanged" object:nil];
        
        [self updateMediaProperties];
        
	}
	
	return self;
}

- (void)receivedMediaNotification:(NSNotification *)mediaNotification {
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
    //if (![self iTunesIsRunning]) return;
    
    if (_iTunes == nil) _iTunes = [[SBApplication applicationWithBundleIdentifier:iTunesBundleIdentifier] retain];
    if (_spotify == nil) _spotify = [[SBApplication applicationWithBundleIdentifier:@"com.spotify.client"] retain];
    
    NSString *iTunesMediaState = [self mediaStateWithPlayerState:[_iTunes playerState] ServerIsRunning:_server.isRunning];
    NSString *spotifyMediaState = [self spotifyMediaStateWithPlayerState:_spotify.playerState ServerIsRunning:_server.isRunning];
    
    if (![iTunesMediaState isEqualToString:kMediaStateIdle]) {
        self.mediaState = iTunesMediaState;
        iTunesTrack *currentTrack = [_iTunes currentTrack];
        
        
        if (nil != _iTunes.currentStreamTitle) {
            self.currentSongData = [MCSongData songDataWithArtist:currentTrack.name 
                                                        SongTitle:_iTunes.currentStreamTitle
                                                            Album:@""
                                    ];
        } else {
            self.currentSongData = [MCSongData songDataWithArtist:currentTrack.artist 
                                                        SongTitle:currentTrack.name
                                                            Album:currentTrack.album
                                    ];
        }
        
    } else if (![spotifyMediaState isEqualToString:kMediaStateIdle]) {
        self.mediaState = spotifyMediaState;
        self.currentSongData = [MCSongData songDataWithArtist:_spotify.currentTrack.artist 
                                                    SongTitle:_spotify.currentTrack.name 
                                                        Album:_spotify.currentTrack.album];
        
    } else {
        self.mediaState = kMediaStateIdle;
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
    [_spotify release];
    [_server release];
    
	[super dealloc];
}

- (NSString*)mediaStateWithPlayerState:(iTunesEPlS)iTunesPlayerState ServerIsRunning:(BOOL)isRunning {
    if (iTunesPlayerState != 0 && iTunesPlayerState != iTunesEPlSStopped && iTunesPlayerState != iTunesEPlSPaused) 
        return isRunning ? kMediaStateBroadcasting : kMediaStatePlaying;
    
    return kMediaStateIdle;
}

- (NSString*)spotifyMediaStateWithPlayerState:(SpotifyEPlS)spotifyPlayerState ServerIsRunning:(BOOL)isRunning {
    if (spotifyPlayerState != 0 && spotifyPlayerState != SpotifyEPlSStopped && spotifyPlayerState != SpotifyEPlSPaused) 
        return isRunning ? kMediaStateBroadcasting : kMediaStatePlaying;
    
    return kMediaStateIdle;
}

@end
