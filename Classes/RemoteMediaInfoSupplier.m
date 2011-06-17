#import "RemoteMediaInfoSupplier.h"
#import "NotificationController.h"

@implementation RemoteMediaInfoSupplier

@synthesize broadcaster;

- (id)initWithBroadcaster:(Broadcaster*)aBroadcaster {
    if ((self = [super init])) {
        
        self.broadcaster = aBroadcaster;
        [self bind:@"currentSongData" toObject:self.broadcaster withKeyPath:@"songData" options:nil];
        
        self.mediaState = kMediaStateListening;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(broadcaterInfoUpdated) name:kBrodcasterTXTRecordUpdateNotification object:self.broadcaster];
    }
    
    return self;
}

- (void)broadcaterInfoUpdated {
    [[NotificationController sharedInstance] postNotificationWithSong:self.currentSongData];
}

- (void)dealloc {
    [self unbind:@"currentSongData"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.broadcaster = nil;
    
    [super dealloc];
}

@end
