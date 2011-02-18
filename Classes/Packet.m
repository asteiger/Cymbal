//
//  Packet.m
//  Djinn
//
//  Created by Ashley Steigerwalt on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Packet.h"

@interface Packet (Private)

- (id)initWithSongData:(MCSongData*)songData;

@end


@implementation Packet

#define ProtocolVersion 1.0

// dictionary/json keys
#define KProtocolVersion @"protocolVersion"
#define KMessageType @"messageType"

#define KSongTitle @"songTitle"
#define KAlbumName @"albumName"
#define KArtistName @"artistName"

// message types
#define SongDataMessage @"SongData"

- (id)init {
	if (self = [super init]) {
		packetData = [[NSMutableDictionary alloc] init];
		
		[packetData setValue:[NSNumber numberWithFloat:ProtocolVersion] forKey:KProtocolVersion];
	}
	
	return self;
}

- (id)initWithJson:(id)json {
	if (self = [super init]) {
		packetData = [[NSMutableDictionary dictionaryWithJSON:json] retain];
	}
	
	return self;
}

- (id)initWithSongData:(MCSongData*)songData {
	if (self = [super init]) {
		packetData = [[NSMutableDictionary alloc] init];
		
		[packetData setValue:[NSNumber numberWithFloat:ProtocolVersion] forKey:KProtocolVersion];
		[packetData setValue:SongDataMessage forKey:KMessageType];
		
		[packetData setValue:songData.songTitle forKey:KSongTitle];
		[packetData setValue:songData.album forKey:KAlbumName];
		[packetData setValue:songData.artist forKey:KArtistName];
	}
	
	return self;
}

+ (Packet*)packetWithSongData:(MCSongData *)songData {
	return [[[self alloc] initWithSongData:songData] autorelease];
}

+ (Packet*)packetWithJson:(id)json {
	return [[[self alloc] initWithJson:json] autorelease];
}

- (NSString*)toJson {
	return [NSString stringWithObjectAsJSON:packetData];
}

- (NSNumber*)protocolVersion {
	return [NSNumber numberWithFloat:ProtocolVersion];
}

- (NSString*)messageType {
	return [packetData objectForKey:KMessageType];
}

- (void)setMessageType:(NSString*)messageType {
	[packetData setValue:messageType forKey:KMessageType];
}

- (MCSongData*)songData {
	MCSongData* songData = nil;
	
	if ([(NSString*)[packetData objectForKey:KMessageType] isEqualToString:SongDataMessage]) {
		NSString *artist = [packetData objectForKey:KArtistName];
		NSString *songTitle = [packetData objectForKey:KSongTitle];
		
		songData = [[MCSongData alloc] initWithArtist:artist SongTitle:songTitle];
	}
	
	return songData;// autorelease];
}

- (void)dealloc {
	[packetData release];
	packetData = nil;
	
	[super dealloc];
}

@end
