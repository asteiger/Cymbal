//
//  MetaCastAppDelegate.h
//  MetaCast
//
//  Created by Ashley Steigerwalt on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MediaListener.h"

@interface MetaCastAppDelegate : NSObject <NSApplicationDelegate> {
	NSStatusItem *statusItem;
	MediaListener *mediaListener;
}

- (NSMenu*)metacastersMenu;

@end
