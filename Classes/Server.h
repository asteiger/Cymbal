@class BroadcasterInfo;

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

- (void)setBroadcasterInfo:(BroadcasterInfo*)info;

@end
