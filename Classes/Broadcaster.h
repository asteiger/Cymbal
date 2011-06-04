

@interface Broadcaster : NSObject <NSNetServiceDelegate> {
    NSNetService *service;
    NSMutableArray *pastSongQueue;
}

+ (Broadcaster*)broadcasterWithNetService:(NSNetService*)aNetService;
- (id)initWithNetService:(NSNetService*)aService;

@end
