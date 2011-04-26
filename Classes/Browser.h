extern NSString *const kAvailableServiceAddedNotification;
extern NSString *const kAvailableServiceRemovedNotification;

@interface Browser : NSObject <NSNetServiceBrowserDelegate> {
    NSString *localName;
	NSNetServiceBrowser *browser;
	NSMutableArray *services;
}

@property (nonatomic, readonly) NSArray *services;
@property (nonatomic, retain) NSString *localName;

- (void)startBrowsing;
- (void)stopBrowsing;
- (NSNetService*)serviceWithName:(NSString*)name;

@end
