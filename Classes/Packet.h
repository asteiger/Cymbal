extern float const kProtocolVersion;
extern NSString *const kProtocolVersionKey;
extern NSString *const kApplicationVersionKey;

@interface Packet : NSObject {
	NSMutableDictionary *packetData;
}

- (id)init;

+ (Packet*)packetWithJson:(id)json;
+ (Packet*)packetWithDictionary:(NSDictionary*)dictionary;

- (NSString*)toJson;
- (NSDictionary*)toDictionary;

- (NSNumber*)protocolVersion;

- (void)setSongData:(MCSongData*)songData;
- (MCSongData*)songData;

@end
