#import "MCSongData.h"

@interface MediaController : NSObject {
    
	NSString *playerState;
    MCSongData *currentSongData;
}

@property (nonatomic, retain) NSString *playerState;
@property (nonatomic, retain) MCSongData *currentSongData;

- (void)receivedItunesNotification:(NSNotification *)mediaNotification;

@end
