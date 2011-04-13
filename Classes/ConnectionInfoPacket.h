#import "Packet.h"

@interface ConnectionInfoPacket : Packet {
    
}

- (id)initWithName:(NSString*)clientName;
- (NSString*)clientName;

@end
