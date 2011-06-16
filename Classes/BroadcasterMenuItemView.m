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
    NSString *strippedArtist = self.currentSongData.artist;

    strippedArtist = [strippedArtist stringByReplacingCharactersInRange:NSMakeRange(0, 64) withString:@""];
    strippedArtist = [strippedArtist stringByReplacingCharactersInRange:NSMakeRange(91, 96) withString:@""];
    strippedArtist = [strippedArtist stringByReplacingCharactersInRange:NSMakeRange(123, 127) withString:@""];
    
    NSString *url = [NSString stringWithFormat:@"http://itunes.com/%@", strippedArtist, nil];
    NSString* escapedUrlString = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:escapedUrlString]];
}

- (NSString*)stringByRemovingSpecialCharacters {
    NSString *start = @"helo*this-is-.the#special string. with (fun chars!";
    
    return start;
}

@end
