//
//  MediaListener.m
//  Djinn
//
//  Created by Ashley Steigerwalt on 1/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MediaController.h"
#import "MCSongData.h"

@implementation MediaController

@synthesize playerState;
@synthesize currentSongData;

#define ItunesStopped @"Stopped"
#define ItunesPaused @"Paused"

- (id)init {
	if ((self = [super init])) {
		[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedItunesNotification:) name:@"com.apple.iTunes.playerInfo" object:nil];
		NSLog(@"Registered iTunes listener");
        
        NSAppleScript *run = [[NSAppleScript alloc] initWithSource:@"tell application \"iTunes\"\nplayer state\nend tell"];
        NSAppleEventDescriptor *aed = [run executeAndReturnError:nil];
        
        NSLog([[aed descriptorForKeyword:@"kPSP"] stringValue]);

        
        self.playerState = @"idle";
	}
	
	return self;
}

- (void)receivedItunesNotification:(NSNotification *)mediaNotification {
	NSLog(@"Got iTunes notification");
	
	self.playerState = [[[mediaNotification userInfo] objectForKey:@"Player State"] description];
	
    if ([self.playerState isEqualToString:ItunesStopped] || [self.playerState isEqualToString:ItunesPaused]) {
        self.currentSongData = nil;
        return;
    }
    
    NSString *artist = [[[mediaNotification userInfo] objectForKey:@"Artist"] description];
	NSString *song = [[[mediaNotification userInfo] objectForKey:@"Name"] description];
	NSString *album = [[[mediaNotification userInfo] objectForKey:@"Album"] description];
	
	self.currentSongData = [MCSongData songDataWithArtist:artist SongTitle:song Album:album];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.playerState = nil;
    
	[super dealloc];
}

@end
