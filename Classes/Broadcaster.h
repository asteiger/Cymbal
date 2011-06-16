#import "BroadcasterInfo.h"
#import "MCSongData.h"

@interface Broadcaster : NSObject <NSNetServiceDelegate> {
    NSNetService *service;
    TXTRecordPacket *info;
    MCSongData *songData;
}

@property (nonatomic, retain) TXTRecordPacket *info;
@property (nonatomic, retain) MCSongData *songData;
@property (nonatomic, readonly) NSString *name;

+ (Broadcaster*)broadcasterWithNetService:(NSNetService*)aNetService;
- (id)initWithNetService:(NSNetService*)aService;

@end
