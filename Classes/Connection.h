#import "AsyncSocket.h"
#import "Packet.h"
#import "SongDataPacket.h"
#import "ConnectionInfoPacket.h"
#import "MCSongData.h"

extern NSString const* kPacketReceivedNotification;

@interface Connection : NSObject <NSNetServiceDelegate> {
    NSString *localName;
	NSString *remoteName;
	AsyncSocket *socket;
}

@property (nonatomic, retain) NSString *localName;
@property (nonatomic, retain) NSString *remoteName;

- (id)initWithNetService:(NSNetService*)aNetService;
- (id)initWithAsyncSocket:(AsyncSocket*)aSocket;

- (void)disconnect;
- (BOOL)isConnected;

- (void)sendPacket:(Packet*)packet;

- (void)didReceiveSongDataPacket:(SongDataPacket*)packet;
- (void)didReceiveConnectionInfoPacket:(ConnectionInfoPacket*)packet;

@end
