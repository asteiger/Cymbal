extern float const kProtocolVersion;
extern NSString *const kProtocolVersionKey;
extern NSString *const kApplicationVersionKey;

@interface BroadcasterInfo : NSObject {
	NSMutableDictionary *packetData;
}

- (id)init;

+ (BroadcasterInfo*)packetWithJson:(id)json;
+ (BroadcasterInfo*)packetWithDictionary:(NSDictionary*)dictionary;

- (NSString*)toJson;
- (NSDictionary*)toDictionary;

- (NSNumber*)protocolVersion;

- (void)setSongData:(MCSongData*)songData;
- (MCSongData*)songData;

@end
