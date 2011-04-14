
@interface Browser : NSObject <NSNetServiceBrowserDelegate> {
	NSNetServiceBrowser *browser;
	NSMutableArray *services;
}

@property (nonatomic, readonly) NSArray *services;

- (void)startBrowsing;
- (void)stopBrowsing;

@end
