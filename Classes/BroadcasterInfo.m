#import "BroadcasterInfo.h"
#import "JSONKit.h"

const float kProtocolVersion = 1.0;

// packet json keys
NSString *const kProtocolVersionKey  = @"protocolVersion";
NSString *const kApplicationVersionKey  = @"applicationVersion";
NSString *const kSongTitleKey  = @"songTitle";
NSString *const kAlbumNameKey  = @"albumName";
NSString *const kArtistNameKey = @"artistName";


@interface BroadcasterInfo (Private)

- (id)initWithJson:(id)json;
- (id)initWithDictionary:(NSDictionary*)dictionary;

@end

@implementation BroadcasterInfo

- (id)init {
	if ((self = [super init])) {
		packetData = [[NSMutableDictionary alloc] init];
		
		[packetData setValue:[NSNumber numberWithFloat:kProtocolVersion] forKey:kProtocolVersionKey];
        [packetData setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:kApplicationVersionKey];
	}
	
	return self;
}

- (id)initWithJson:(id)json {
	if ((self = [super init])) {
		packetData = [[NSMutableDictionary dictionaryWithJSON:json] retain];
	}
	
	return self;
}

- (id)initWithDictionary:(NSDictionary*)dictionary {
	if ((self = [super init])) {
		packetData = [[NSMutableDictionary dictionaryWithDictionary:dictionary] retain];
	}
	
	return self;
}

+ (BroadcasterInfo*)packetWithJson:(id)json {    
	return [[[BroadcasterInfo alloc] initWithJson:json] autorelease];
}

+ (BroadcasterInfo*)packetWithDictionary:(NSDictionary *)dictionary {
	return [[[BroadcasterInfo alloc] initWithDictionary:dictionary] autorelease];
}

- (NSString*)toJson {
	return [NSString stringWithObjectAsJSON:packetData];
}

- (NSDictionary*)toDictionary {
    return packetData;
}

- (NSNumber*)protocolVersion {
	return [NSNumber numberWithFloat:kProtocolVersion];
}

- (void)setSongData:(MCSongData*)songData {
    [packetData setValue:songData.songTitle forKey:kSongTitleKey];
    [packetData setValue:songData.album forKey:kAlbumNameKey];
    [packetData setValue:songData.artist forKey:kArtistNameKey];
}

- (MCSongData*)songData {
	MCSongData* songData = nil;
	
    NSString *artist = [packetData objectForKey:kArtistNameKey];
    NSString *songTitle = [packetData objectForKey:kSongTitleKey];
    NSString *album = [packetData objectForKey:kAlbumNameKey];
    
    songData = [[MCSongData alloc] initWithArtist:artist SongTitle:songTitle Album:album];
	
	return [songData autorelease];
}

- (void)dealloc {
	[packetData release];
	packetData = nil;
	
	[super dealloc];
}

@end
