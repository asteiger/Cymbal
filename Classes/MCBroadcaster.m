#import "MCBroadcaster.h"

@implementation MCBroadcaster

@synthesize service, connected;

- (id)initWithService:(NSNetService*)aService {
	if (self = [super init]) {
		self.service = aService;
		self.connected = NO;
	}
	
	return self;
}

- (void)dealloc {
	self.service = nil;
	[super dealloc];
}

@end
