#import "BroadcasterInfo.h"

@interface Broadcaster : NSObject <NSNetServiceDelegate> {
    NSNetService *service;
    BroadcasterInfo *info;
}

@property (nonatomic, retain) BroadcasterInfo *info;

+ (Broadcaster*)broadcasterWithNetService:(NSNetService*)aNetService;
- (id)initWithNetService:(NSNetService*)aService;

@end
