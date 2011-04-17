@class AsyncSocket;
@class Packet;

extern NSString *const kListenerConnectedNotification;
extern NSString *const kListenerDisconnectedNotification;
extern NSString *const kListenerNameKey;

@interface Server : NSObject <NSNetServiceDelegate> {
    NSString *name;
	NSNetService *netService;
	AsyncSocket *serverSocket;
	
	NSMutableArray *connections;
	
	BOOL isRunning;
}

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSMutableArray *connections;
@property (nonatomic, readonly) BOOL isRunning;

- (id)init;
- (BOOL)start;
- (void)stop;

- (void)broadcastPacket:(Packet*)packet;

@end
