//
//  MCStatusMenu.h
//  Djinn
//
//  Created by Ashley Steigerwalt on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MCMetacaster.h"
#import "MCApplicationController.h"

typedef enum {
	kApplicationStatus = 1,
	kListeners = 2,
	kNothingPlaying = 3,
	kCurrentSong = 4,
	kCurrentArtist = 5,
	kMetacastToggle = 6,
	kMetacasters = 7,
	kPreferences = 8,
	kQuit = 9
} MCMenuItemType;

@interface MCStatusMenu : NSObject {
	NSStatusItem *statusItem;
	NSMenu *appMenu;
}

+ (MCStatusMenu*)sharedMCStatusMenu;

- (void)setNoMediaInfo;
- (void)updateCurrentArtist:(NSString*)artist Song:(NSString*)song;
- (void)updateAppStatusMenuItem;
- (void)addBroadcaster:(MCMetacaster*)name;


@end
