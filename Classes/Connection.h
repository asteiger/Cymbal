//
//  Connection.h
//  Djinn
//
//  Created by Ashley Steigerwalt on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AsyncSocket.h"

@interface Connection : NSObject {
	NSNetService *netService;
	AsyncSocket *socket;
}

- (id)initWithNetService:(NSNetService*)aNetService ShouldConnect:(BOOL)shouldConnect;
- (void)connect;
- (void)disconnect;

- (BOOL)isConnected;

@end
