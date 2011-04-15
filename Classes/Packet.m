#import "Packet.h"
#import "JSONKit.h"

const float kProtocolVersion = 1.0;

// packet json keys
NSString *const kProtocolVersionKey  = @"protocolVersion";
NSString *const kPacketTypeKey       = @"packetType";
NSString *const kSenderNameKey       = @"senderName";

@interface Packet (Private)

- (id)initWithJson:(id)json;
- (id)initWithDictionary:(NSDictionary*)dictionary;

@end

@implementation Packet

- (id)init {
	if ((self = [super init])) {
		packetData = [[NSMutableDictionary alloc] init];
		
		[packetData setValue:[NSNumber numberWithFloat:kProtocolVersion] forKey:kProtocolVersionKey];
        [packetData setValue:NSStringFromClass([self class]) forKey:kPacketTypeKey];
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

+ (Packet*)packetWithJson:(id)json {
    NSString *packetType = [[NSMutableDictionary dictionaryWithJSON:json] valueForKey:kPacketTypeKey];
    
	return [[[NSClassFromString(packetType) alloc] initWithJson:json] autorelease];
}

+ (Packet*)packetWithDictionary:(NSDictionary *)dictionary {
    NSString *packetType = [dictionary valueForKey:kPacketTypeKey];
    
	return [[[NSClassFromString(packetType) alloc] initWithDictionary:dictionary] autorelease];
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

- (NSString*)senderName {
	return [packetData objectForKey:kSenderNameKey];
}

- (void)dealloc {
	[packetData release];
	packetData = nil;
	
	[super dealloc];
}

@end
