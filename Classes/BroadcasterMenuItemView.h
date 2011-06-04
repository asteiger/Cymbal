#import "MCSongData.h"

@interface BroadcasterMenuItemView : NSView {
    IBOutlet NSTextField *shareNameField;
    IBOutlet NSTextField *songNameField;
    IBOutlet NSTextField *artistNameField;
    IBOutlet NSTextField *albumNameField;
    
    NSString *shareName;
    MCSongData *currentSongData;
}

@property (nonatomic, retain) NSString *shareName;
@property (nonatomic, retain) MCSongData *currentSongData;

@end
