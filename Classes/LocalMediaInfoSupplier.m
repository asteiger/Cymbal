#import "LocalMediaInfoSupplier.h"
#import "TXTRecordPacket.h"
#import "MCSongData.h"
#import "NotificationController.h"
#import "PreferencesController.h"
#import "NSString+CymbalAdditions.h"
#import "ApplicationHelper.h"
#import <ObjectiveMetrics/ObjectiveMetrics.h>

NSString *const iTunesBundleIdentifier = @"com.apple.iTunes";

@interface LocalMediaInfoSupplier (Private)
- (NSString*)mediaStateWithPlayerState:(iTunesEPlS)iTunesPlayerState ServerIsRunning:(BOOL)isRunning;
- (NSString*)spotifyMediaStateWithPlayerState:(SpotifyEPlS)iTunesPlayerState ServerIsRunning:(BOOL)isRunning;
- (NSString*)rdioMediaStateWithPlayerState:(RdioEPSS)rdioPlayerState ServerIsRunning:(BOOL)isRunning; 
@end

@implementation LocalMediaInfoSupplier

- (id)initWithServer:(Server*)server {
	if ((self = [super init])) {
        _server = [server retain];
        
        
		[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedMediaNotification:) name:@"com.apple.iTunes.playerInfo" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedMediaNotification:) name:@"SpotifyPlayerStateChanged" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedMediaNotification:) name:@"RdioPlayerStateChanged" object:nil];
        
        [self updateMediaProperties];
        
	}
	
	return self;
}

- (void)receivedMediaNotification:(NSNotification *)mediaNotification {
	NSLog(@"Got media notification");
    
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

    NSString *iTunesMediaState = kMediaStateIdle;
    NSString *spotifyMediaState = kMediaStateIdle;
    NSString *rdioMediaState = kMediaStateIdle;
    
    if ([ApplicationHelper applicationIsRunning:kItunesBundleIdentifier]) {
        if (_iTunes == nil) _iTunes = [[SBApplication applicationWithBundleIdentifier:kItunesBundleIdentifier] retain];

        iTunesMediaState = [self mediaStateWithPlayerState:_iTunes.playerState ServerIsRunning:_server.isRunning];
    }
    
    if ([ApplicationHelper applicationIsRunning:kSpotifyBundleIdentifier]) {
        if (_spotify == nil) _spotify = [[SBApplication applicationWithBundleIdentifier:kSpotifyBundleIdentifier] retain];
        
        spotifyMediaState = [self spotifyMediaStateWithPlayerState:_spotify.playerState ServerIsRunning:_server.isRunning];
    }
    
    if ([ApplicationHelper applicationIsRunning:kRdioBundleIdentifier]) {
        if (_rdio == nil) _rdio = [[SBApplication applicationWithBundleIdentifier:kRdioBundleIdentifier] retain];
        
        rdioMediaState = [self rdioMediaStateWithPlayerState:_rdio.playerState ServerIsRunning:_server.isRunning];
    }
    
    
    if (![iTunesMediaState isEqualToString:kMediaStateIdle]) {
        [[DMTracker defaultTracker] trackCustomDataRealtimeWithName:@"Broadcast Started" value:@"iTunes"];
        
        self.mediaState = iTunesMediaState;
        iTunesTrack *currentTrack = [_iTunes currentTrack];
        
        
        if (nil != _iTunes.currentStreamTitle) {
            self.currentSongData = [MCSongData songDataWithArtist:[currentTrack.name stringOrNilForBlankString]
                                                        SongTitle:[_iTunes.currentStreamTitle stringOrNilForBlankString]
                                                            Album:nil];
        } else {
            self.currentSongData = [MCSongData songDataWithArtist:[currentTrack.artist stringOrNilForBlankString]
                                                        SongTitle:[currentTrack.name stringOrNilForBlankString]
                                                            Album:[currentTrack.album stringOrNilForBlankString]];
        }
        
    } else if (![spotifyMediaState isEqualToString:kMediaStateIdle]) {
        self.mediaState = spotifyMediaState;
        
        NSRange httpRange = [_spotify.currentTrack.album rangeOfString:@"http://"];
        NSRange spotifyRange = [_spotify.currentTrack.album rangeOfString:@"spotify:"];
        BOOL isSpotifyAd = httpRange.location == 0 || spotifyRange.location == 0;
        
        self.currentSongData = [MCSongData songDataWithArtist:[_spotify.currentTrack.artist stringOrNilForBlankString]
                                                    SongTitle:[_spotify.currentTrack.name stringOrNilForBlankString]
                                                        Album:isSpotifyAd ? nil : [_spotify.currentTrack.album stringOrNilForBlankString]];
        
    } else if (![rdioMediaState isEqualToString:kMediaStateIdle]) {
        self.mediaState = rdioMediaState;
        self.currentSongData = [MCSongData songDataWithArtist:[_rdio.currentTrack.artist stringOrNilForBlankString]
                                                    SongTitle:[_rdio.currentTrack.name stringOrNilForBlankString]
                                                        Album:[_rdio.currentTrack.album stringOrNilForBlankString]];
    }
    else {
        self.mediaState = kMediaStateIdle;
    }
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

- (NSString*)rdioMediaStateWithPlayerState:(RdioEPSS)rdioPlayerState ServerIsRunning:(BOOL)isRunning {
    if (rdioPlayerState != 0 && rdioPlayerState != RdioEPSSStopped && rdioPlayerState != RdioEPSSPaused) 
        return isRunning ? kMediaStateBroadcasting : kMediaStatePlaying;
    
    return kMediaStateIdle;
}

@end
