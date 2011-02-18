//
//  Packet.h
//  Djinn
//
//  Created by Ashley Steigerwalt on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JSONKit.h"
#import "MCSongData.h"

@interface Packet : NSObject {
	NSDictionary *packetData;
}

- (id)init;
- (id)initWithJson:(id)json;

+ (Packet*)packetWithSongData:(MCSongData*)songData;

- (NSString*)toJson;

- (NSNumber*)protocolVersion;
- (void)setProtocolVersion:(NSNumber*)protocolVersion;

- (NSString*)messageType;
- (void)setMessageType:(NSString*)messageType;

- (MCSongData*)songData;

@end
