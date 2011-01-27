//
//  MetaCastAppDelegate.h
//  MetaCast
//
//  Created by Ashley Steigerwalt on 1/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MediaListener.h"
#import "MCServer.h"

@interface MetaCastAppDelegate : NSObject <NSApplicationDelegate> {
	MCServer *mcServer;
	MediaListener *mediaListener;
}


@end
