//
//  MCStatusMenu.h
//  MetaCast
//
//  Created by Ashley Steigerwalt on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MCMetacaster.h"

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

typedef enum {
	kIdle = 1,
	kMetacasting = 2,
	kListening = 3
} MCApplicationStatus;

@interface MCStatusMenu : NSObject {
	NSStatusItem *statusItem;
	NSMenu *appMenu;
}

+ (MCStatusMenu*)sharedMCStatusMenu;

- (void)setNoMediaInfo;
- (void)updateCurrentArtist:(NSString*)artist Song:(NSString*)song;
- (void)updateAppStatus:(MCApplicationStatus)status;
- (void)addMetacaster:(MCMetacaster*)name;


@end
