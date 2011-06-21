extern float const kProtocolVersion;
extern NSString *const kProtocolVersionKey;
extern NSString *const kApplicationVersionKey;

@interface TXTRecordPacket : NSObject {
	NSMutableDictionary *packetData;
}

- (id)init;

+ (TXTRecordPacket*)packetWithJson:(id)json;
+ (TXTRecordPacket*)packetWithDictionary:(NSDictionary*)dictionary;

- (NSString*)toJson;
- (NSDictionary*)toDictionary;

- (NSNumber*)protocolVersion;

- (void)setSongData:(MCSongData*)songData;
- (MCSongData*)songData;

@end
