extern NSString *const kAvailableServiceAddedNotification;
extern NSString *const kAvailableServiceRemovedNotification;

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

@end
