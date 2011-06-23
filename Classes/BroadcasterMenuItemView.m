#import "BroadcasterMenuItemView.h"
#import "NSString+CharacterRemoval.h"
#import "MediaInfoSupplier.h"
#import "RemoteMediaInfoSupplier.h"


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
    
    int pos = [APP_DELEGATE.browser positionOfBroadcasterWithName:self.shareName];
    
    if (pos % 2) {
        [[NSColor colorWithPatternImage:[NSImage imageNamed:@"crosshatch.png"]] setFill];
        NSRectFill(dirtyRect);
    }
    
    if (shareNameField == nil || self.currentSongData == nil) return;
    [shareNameField setStringValue:shareName];
    
    NSString *songTitle = [self.currentSongData.songTitle length] != 0 ? self.currentSongData.songTitle : @"";
    NSString *songArtist = [self.currentSongData.artist length] != 0 ? self.currentSongData.artist : @"";
    NSString *songAlbum = [self.currentSongData.album length] != 0 ? self.currentSongData.album : @"";
    
    [songNameField setStringValue:songTitle];
    [artistNameField setStringValue:songArtist];
    [albumNameField setStringValue:songAlbum];
    
    [followButton setEnabled:YES];
    [followButton setTitle:@"Follow"];
    
    MediaInfoSupplier *infoSupplier = APP_DELEGATE.mediaInfoSupplier;
    if ([infoSupplier isKindOfClass:[RemoteMediaInfoSupplier class]]) {
        
        RemoteMediaInfoSupplier *remoteInfo = (RemoteMediaInfoSupplier*)infoSupplier;
        if ([remoteInfo.broadcaster.name isEqualToString:self.shareName]) {
            [followButton setTitle:@"Following"];
            [followButton setEnabled:NO];
        }
    }
    
    
}

- (IBAction)searchForSongOnITunes:(id)sender {
    NSString *strippedArtist = self.currentSongData.artist;

    strippedArtist = [strippedArtist stringByReplacingOccurrencesOfString:@"&" withString:@"And"];
    strippedArtist = [strippedArtist stringByRemovingSpecialCharacters];
    
    NSString *url = [NSString stringWithFormat:@"http://itunes.com/%@", strippedArtist, nil];
    NSString* escapedUrlString = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:escapedUrlString]];
}

- (IBAction)didClickFollow:(id)sender {
    [APP_DELEGATE follow:self.shareName];
    [followButton setTitle:@"Following"];
    [followButton setEnabled:NO];
    
}

@end




