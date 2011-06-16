@class TXTRecordPacket;

extern NSString *const kBroadcasterInfoKey;

@interface Server : NSObject <NSNetServiceDelegate> {
    NSString *name;
	NSNetService *netService;
	
	BOOL isRunning;
}

@property (nonatomic, readonly) NSString *name;
@property (nonatomic) BOOL isRunning;

- (id)init;
- (BOOL)start;
- (void)stop;

- (void)setTXTRecord:(TXTRecordPacket*)info;

@end
