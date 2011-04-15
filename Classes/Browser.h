extern NSString *const kServiceNameKey;
extern NSString *const kAvailableServiceAddedNotification;
extern NSString *const kAvailableServiceRemovedNotification;

@interface Browser : NSObject <NSNetServiceBrowserDelegate> {
	NSNetServiceBrowser *browser;
	NSMutableArray *services;
}

@property (nonatomic, readonly) NSArray *services;

- (void)startBrowsing;
- (void)stopBrowsing;
- (NSNetService*)serviceWithName:(NSString*)name;

@end
