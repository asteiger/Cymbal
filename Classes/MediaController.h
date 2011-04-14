#import "MCSongData.h"

@interface MediaController : NSObject

@property (nonatomic, retain) NSString *playerState;
@property (nonatomic, retain) MCSongData *currentSongData;

@end
