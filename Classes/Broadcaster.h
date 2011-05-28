

@interface Broadcaster : NSObject <NSNetServiceDelegate> {
    NSNetService *service;
    
}

+ (Broadcaster*)broadcasterWithNetService:(NSNetService*)aNetService;
- (id)initWithNetService:(NSNetService*)aService;

@end
