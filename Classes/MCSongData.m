#import "MCSongData.h"

@implementation MCSongData

@synthesize artist = _artist;
@synthesize songTitle = _songTitle;
@synthesize album = _album;

+ (MCSongData*)songDataWithArtist:(NSString*)artist SongTitle:(NSString*)songTitle Album:(NSString*)album {
    return [[[self alloc] initWithArtist:artist SongTitle:songTitle Album:album] autorelease];
}

- (id)initWithArtist:(NSString*)artist SongTitle:(NSString*)songTitle Album:(NSString*)album {
	if ((self = [super init])) {
		self.artist = artist;
		self.songTitle = songTitle;
        self.album = album;
	}
	
	return self;
}

- (void)dealloc {
	self.artist = nil;
	self.songTitle = nil;
	self.album = nil;
	
	[super dealloc];
}

@end
