//
//  Packet.m
//  Djinn
//
//  Created by Ashley Steigerwalt on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Packet.h"


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
		packetData = [[NSDictionary alloc] init];
		
		[packetData setValue:[NSNumber numberWithFloat:ProtocolVersion] forKey:KProtocolVersion];
	}
	
	return self;
}

- (id)initWithJson:(id)json {
	if (self = [super init]) {
		packetData = [[NSDictionary dictionaryWithJSON:json] retain];
	}
	
	return self;
}

+ (Packet*)packetWithSongData:(MCSongData *)songData {
	self = [[Packet alloc] init];
	
	[packetData setValue:SongDataMessage forKey:KMessageType];
	[packetData setValue:songData.songTitle forKey:KSongTitle];
	[packetData setValue:songData.album forKey:KAlbumName];
	[packetData setValue:songData.artist forKey:KArtistName];
	
	return [self autorelease];
}

- (NSString*)toJson {
	return [NSString stringWithObjectAsJSON:packetData];
}

- (void)dealloc {
	[packetData release];
	packetData = nil;
	
	[super dealloc];
}

@end
