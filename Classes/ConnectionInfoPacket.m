#import "ConnectionInfoPacket.h"

static NSString *kClientName  = @"hostName";

@implementation ConnectionInfoPacket

- (id)initWithName:(NSString*)clientName {
    if ((self == [super init])) {
        [packetData setValue:clientName forKey:kClientName];
    }
        
    return self;
}

- (NSString*)clientName {
    return [packetData valueForKey:kClientName];
}

@end
