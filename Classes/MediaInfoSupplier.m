#import "MediaInfoSupplier.h"

NSString *const kMediaStateIdle = @"Idle";
NSString *const kMediaStatePlaying = @"Playing";
NSString *const kMediaStateBroadcasting = @"Broadcasting";
NSString *const kMediaStateListening = @"Listening";

@implementation MediaInfoSupplier

@synthesize mediaState = _mediaState;
@synthesize currentSongData = _currentSongData;

- (void)updateMediaProperties { }

- (void)dealloc {
    self.mediaState = nil;
    self.currentSongData = nil;
    
    [super dealloc];
}

@end