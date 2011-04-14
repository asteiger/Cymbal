#import "MCSongData.h"

extern NSString *const kMediaStateIdle;
extern NSString *const kMediaStatePlaying;
extern NSString *const kMediaStateBroadcasting;
extern NSString *const kMediaStateListening;

@interface MediaInfoSupplier : NSObject {
    NSString *_mediaState;
    MCSongData *_currentSongData;
}

@property (nonatomic, retain) NSString *mediaState;
@property (nonatomic, retain) MCSongData *currentSongData;

- (void)updateMediaProperties;

@end
