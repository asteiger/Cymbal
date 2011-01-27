//
//  MediaListener.h
//  MetaCast
//
//  Created by Ashley Steigerwalt on 1/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MediaListener : NSObject {

}

- (void)receivedItunesNotification:(NSNotification *)mediaNotification;

@end
