//
//  MCServer.m
//  MetaCast
//
//  Created by Ashley Steigerwalt on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MCServer.h"

@implementation MCServer

- (id)init {
	if (self = [super init]) {
		
	}
	
	return self;
}

-(void)startService {
    netService = [[NSNetService alloc] initWithDomain:@"" type:@"_metacast._tcp." 
												 name:@"" port:7865];
    netService.delegate = self;
    [netService publish];
}

-(void)stopService {
    [netService stop];
    [netService release]; 
    netService = nil;
}

-(void)dealloc {
    [self stopService];
    [super dealloc];
}

#pragma mark Net Service Delegate Methods
-(void)netService:(NSNetService *)aNetService didNotPublish:(NSDictionary *)dict {
    NSLog(@"Failed to publish: %@", dict);
}

@end
