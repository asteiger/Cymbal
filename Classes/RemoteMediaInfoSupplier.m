#import "RemoteMediaInfoSupplier.h"
#import "MCGrowlController.h"

@interface RemoteMediaInfoSupplier (Private) 

- (void)receivedPacketNotification:(NSNotification*)notification;

@end

@implementation RemoteMediaInfoSupplier

- (id)initWithConnection:(Connection*)connection {
    if ((self = [super init])) {
        _connection = [connection retain];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(receivedPacketNotification:) 
                                                     name:(NSString*)kPacketReceivedNotification 
                                                   object:_connection];
        [self updateMediaProperties];
    }
    
    return self;
}

- (void)updateMediaProperties {
    if ([_connection isConnected]) self.mediaState = kMediaStateListening;
    else self.mediaState = kMediaStateIdle;
}

- (void)receivedPacketNotification:(NSNotification*)notification {
    NSLog(@"Remote media supplier got Packet Notification");
    id p = [Packet packetWithDictionary:[notification userInfo]];
    
    if ([p isKindOfClass:[SongDataPacket class]]) {
        self.currentSongData = [(SongDataPacket*)p songData];
        [MCGrowlController postNotificationWithSong:self.currentSongData];
    }
    
    if ([_connection isConnected]) self.mediaState = kMediaStateListening;
    else self.mediaState = kMediaStateIdle;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:(NSString*)kPacketReceivedNotification object:_connection];
    [_connection release];
    
    [super dealloc];
}

@end
