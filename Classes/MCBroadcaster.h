//
//  Djinner.h
//  Djinn
//
//  Created by Ashley Steigerwalt on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Connection.h"

@interface MCBroadcaster : NSObject {
	NSNetService *service;
	Connection *connection;
	BOOL connected;
}

@property (nonatomic, retain) NSNetService *service;
@property BOOL connected;

- (id)initWithService:(NSNetService*)aService;

@end
