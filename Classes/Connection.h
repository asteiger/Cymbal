#import "AsyncSocket.h"
#import "Packet.h"
#import "SongDataPacket.h"
#import "ConnectionInfoPacket.h"
#import "MCSongData.h"

extern NSString const* kPacketReceivedNotification;

@interface Connection : NSObject <NSNetServiceDelegate> {
	NSString *remoteName;
	AsyncSocket *socket;
}

- (id)initWithNetService:(NSNetService*)aNetService;
- (id)initWithAsyncSocket:(AsyncSocket*)aSocket;

- (void)disconnect;
- (BOOL)isConnected;
- (NSString*)remoteName;

- (void)sendPacket:(Packet*)packet;

- (void)didReceiveSongDataPacket:(SongDataPacket*)packet;
- (void)didReceiveConnectionInfoPacket:(ConnectionInfoPacket*)packet;

@end
