#import "Connection.h"

@interface MCBroadcaster : NSObject {
	NSNetService *service;
	Connection *connection;
	BOOL connected;
}

@property (nonatomic, retain) NSNetService *service;
@property BOOL connected;

- (id)initWithService:(NSNetService*)aService;

@end
