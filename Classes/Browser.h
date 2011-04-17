extern NSString *const kServiceNameKey;
extern NSString *const kAvailableServiceAddedNotification;
extern NSString *const kAvailableServiceRemovedNotification;

@interface Browser : NSObject <NSNetServiceBrowserDelegate> {
    NSString *localName;
	NSNetServiceBrowser *browser;
	NSMutableArray *services;
}

@property (nonatomic, readonly) NSArray *services;
@property (nonatomic, retain) NSString *localName;

- (id)initWithLocalName:(NSString*)name;

- (void)startBrowsing;
- (void)stopBrowsing;
- (NSNetService*)serviceWithName:(NSString*)name;

@end
