#import "MediaController.h"

NSString *const kMediaStateIdle = @"Idle";
NSString *const kMediaStatePlaying = @"Playing";
NSString *const kMediaStateBroadcasting = @"Broadcasting";
NSString *const kMediaStateListening = @"Listening";

@implementation MediaController

@synthesize mediaState = _mediaState;
@synthesize currentSongData = _currentSongData;

@end