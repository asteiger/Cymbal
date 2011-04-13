#import "Packet.h"

@class MCSongData;

@interface SongDataPacket : Packet {
    
}

+ (Packet*)packetWithSongData:(MCSongData*)songData;

- (id)initWithSongData:(MCSongData*)songData;

- (MCSongData*)songData;

- (void)process;

@end
