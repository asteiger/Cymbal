#import "Broadcaster.h"

extern NSString *const kAvailableBroadcasterAddedNotification;
extern NSString *const kAvailableBroadcasterRemovedNotification;

@interface Browser : NSObject <NSNetServiceBrowserDelegate> {
    NSString *localName;
	NSNetServiceBrowser *browser;
    
	NSMutableArray *services;
    NSMutableArray *broadcasters;
}

@property (nonatomic, readonly) NSArray *services;

- (void)startBrowsing;
- (void)stopBrowsing;
- (NSNetService*)serviceWithName:(NSString*)name;

- (Broadcaster*)availableBroadcasterWithName:(NSString*)name;
@end
