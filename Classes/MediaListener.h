//
//  MediaListener.h
//  Djinn
//
//  Created by Ashley Steigerwalt on 1/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MCApplicationController.h"
#import "MCStatusMenu.h"

@interface MediaListener : NSObject {
	NSString *_playerState;
}

- (void)receivedItunesNotification:(NSNotification *)mediaNotification;

@end
