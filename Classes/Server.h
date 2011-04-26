@class AsyncSocket;
@class Packet;

extern NSString *const kListenerConnectedNotification;

@interface Server : NSObject <NSNetServiceDelegate> {
    NSString *name;
	NSNetService *netService;
	AsyncSocket *serverSocket;
	
	NSMutableArray *connections;
	
	BOOL isRunning;
}

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSMutableArray *connections;
@property (nonatomic) BOOL isRunning;

- (id)init;
- (BOOL)start;
- (void)stop;

- (void)broadcastPacket:(Packet*)packet;

@end
