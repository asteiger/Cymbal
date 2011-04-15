extern float const kProtocolVersion;
extern NSString *const kProtocolVersionKey;
extern NSString *const kPacketTypeKey;
extern NSString *const kSenderNameKey;

@interface Packet : NSObject {
	NSMutableDictionary *packetData;
}

- (id)init;

+ (Packet*)packetWithJson:(id)json;
+ (Packet*)packetWithDictionary:(NSDictionary*)dictionary;

- (NSString*)toJson;
- (NSDictionary*)toDictionary;

- (NSNumber*)protocolVersion;
- (NSString*)senderName;

@end
