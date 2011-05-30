#import "BroadcasterMenuItemView.h"


@implementation BroadcasterMenuItemView

@synthesize shareName;
@synthesize currentSongData;

- (id)initWithFrame:(NSRect)frame {
    if ((self = [super initWithFrame:frame])) {
        
    }
    
    return self;
}

- (void)dealloc {
    self.shareName = nil;
    self.currentSongData = nil;
    
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect {
    [shareNameField setStringValue:shareName];
    
    if (self.currentSongData == nil) return;
    [songNameField setStringValue:currentSongData.songTitle];
    [artistNameField setStringValue:currentSongData.artist];
    [albumNameField setStringValue:currentSongData.album];
}

@end
