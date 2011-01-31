//
//  Djinner.m
//  Djinn
//
//  Created by Ashley Steigerwalt on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MCMetacaster.h"

@implementation MCMetacaster

@synthesize service, connected;

- (id)initWithService:(NSNetService*)aService {
	if (self = [super init]) {
		self.service = aService;
		self.connected = NO;
	}
	
	return self;
}

- (void)dealloc {
	self.service = nil;
	[super dealloc];
}

@end
