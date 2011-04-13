#import "SongDataPacket.h"
#import "MCSongData.h"

static NSString *kSongTitleKey  = @"songTitle";
static NSString *kAlbumNameKey  = @"albumName";
static NSString *kArtistNameKey = @"artistName";

@implementation SongDataPacket

- (id)initWithSongData:(MCSongData*)songData {
	if ((self = [super init])) {		
		[packetData setValue:songData.songTitle forKey:kSongTitleKey];
		[packetData setValue:songData.album forKey:kAlbumNameKey];
		[packetData setValue:songData.artist forKey:kArtistNameKey];
	}
	
	return self;
}

+ (Packet*)packetWithSongData:(MCSongData *)songData {
	return [[[self alloc] initWithSongData:songData] autorelease];
}

- (MCSongData*)songData {
	MCSongData* songData = nil;
	
    NSString *artist = [packetData objectForKey:kArtistNameKey];
    NSString *songTitle = [packetData objectForKey:kSongTitleKey];
    NSString *album = [packetData objectForKey:kAlbumNameKey];
		
    songData = [[MCSongData alloc] initWithArtist:artist SongTitle:songTitle Album:album];
	
	return [songData autorelease];
}

- (void)process {
    // do great things here
}

@end
