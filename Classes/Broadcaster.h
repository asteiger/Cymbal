#import "BroadcasterInfo.h"
#import "MCSongData.h"

extern NSString *const kBrodcasterTXTRecordUpdateNotification;

@interface Broadcaster : NSObject <NSNetServiceDelegate> {
    NSNetService *service;
    MCSongData *songData;
}

@property (nonatomic, retain) MCSongData *songData;
@property (nonatomic, readonly) NSString *name;

+ (Broadcaster*)broadcasterWithNetService:(NSNetService*)aNetService;
- (id)initWithNetService:(NSNetService*)aService;

@end
