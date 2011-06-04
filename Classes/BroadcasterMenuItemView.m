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

- (IBAction)searchForSongOnITunes:(id)sender {
    NSString *strippedArtist = [self.currentSongData.artist stringByReplacingOccurrencesOfString:@" " withString:@""];
    strippedArtist = [strippedArtist stringByReplacingOccurrencesOfString:@"&" withString:@"And"];
    strippedArtist = [strippedArtist stringByReplacingOccurrencesOfString:@"." withString:@""];
    strippedArtist = [strippedArtist stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSString *url = [NSString stringWithFormat:@"http://itunes.com/%@", strippedArtist, nil];
    NSString* escapedUrlString = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:escapedUrlString]];
}

@end
