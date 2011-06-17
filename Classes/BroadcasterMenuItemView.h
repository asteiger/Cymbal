#import "MCSongData.h"

@interface BroadcasterMenuItemView : NSView {
    IBOutlet NSTextField *shareNameField;
    IBOutlet NSTextField *songNameField;
    IBOutlet NSTextField *artistNameField;
    IBOutlet NSTextField *albumNameField;
    IBOutlet NSButton *followButton;
    
    NSString *shareName;
    MCSongData *currentSongData;
}

@property (nonatomic, retain) NSString *shareName;
@property (nonatomic, retain) MCSongData *currentSongData;

- (IBAction)searchForSongOnITunes:(id)sender;
- (IBAction)didClickFollow:(id)sender;
@end

