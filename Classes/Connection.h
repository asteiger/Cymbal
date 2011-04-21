#import "AsyncSocket.h"
#import "Packet.h"
#import "SongDataPacket.h"
#import "ConnectionInfoPacket.h"
#import "MCSongData.h"

extern NSString *const kPacketReceivedNotification;
extern NSString *const kConnectionDisconnectedNotification;

@interface Connection : NSObject <NSNetServiceDelegate> {
    NSString *localName;
	NSString *remoteName;
	AsyncSocket *socket;
}

@property (nonatomic, retain) NSString *localName;
@property (nonatomic, retain) NSString *remoteName;

- (id)initWithNetService:(NSNetService*)aNetService LocalName:(NSString*)name;
- (id)initWithAsyncSocket:(AsyncSocket*)aSocket LocalName:(NSString*)name;

- (void)disconnect;
- (BOOL)isConnected;

- (void)sendPacket:(Packet*)packet;

- (void)didReceiveConnectionInfoPacket:(ConnectionInfoPacket*)packet;

@end
