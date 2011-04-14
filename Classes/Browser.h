
@interface Browser : NSObject <NSNetServiceBrowserDelegate> {
	NSNetServiceBrowser *browser;
	NSMutableArray *services;
}

- (void)startBrowsing;
- (void)stopBrowsing;

@end
