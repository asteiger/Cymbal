//
//  Djinner.h
//  Djinn
//
//  Created by Ashley Steigerwalt on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MCMetacaster : NSObject {
	NSNetService *service;
	BOOL connected;
}

@property (nonatomic, retain) NSNetService *service;
@property BOOL connected;

- (id)initWithService:(NSNetService*)aService;

@end
