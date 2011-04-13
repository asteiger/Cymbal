@class AsyncSocket;
@class Packet;

@interface Server : NSObject <NSNetServiceDelegate> {
	NSNetService *netService;
	AsyncSocket *serverSocket;
	
	NSMutableArray *connections;
	
	BOOL isRunning;
}

@property (nonatomic, readonly) NSMutableArray *connections;
@property (nonatomic, readonly) BOOL isRunning;

- (id)init;
- (BOOL)start;
- (void)stop;

- (void)broadcastPacket:(Packet*)packet;

@end
