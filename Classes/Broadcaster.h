#import "BroadcasterInfo.h"
#import "MCSongData.h"

@interface Broadcaster : NSObject <NSNetServiceDelegate> {
    NSNetService *service;
    BroadcasterInfo *info;
    MCSongData *songData;
}

@property (nonatomic, retain) BroadcasterInfo *info;
@property (nonatomic, retain) MCSongData *songData;
@property (nonatomic, readonly) NSString *name;

+ (Broadcaster*)broadcasterWithNetService:(NSNetService*)aNetService;
- (id)initWithNetService:(NSNetService*)aService;

@end
