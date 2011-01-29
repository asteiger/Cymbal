//
//  MCStatusMenu.h
//  MetaCast
//
//  Created by Ashley Steigerwalt on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum {
	kApplicationStatus = 1,
	kNothingPlaying = 2,
	kCurrentSong = 3,
	kCurrentArtist = 4,
	kMetacastToggle = 5,
	kMetacasters = 6,
	kPreferences = 7,
	kQuit = 8
} MCMenuItemType;

@interface MCStatusMenu : NSObject {
	NSStatusItem *statusItem;
	NSMenu *appMenu;
}

+ (MCStatusMenu*)sharedMCStatusMenu;

- (void)setNoMediaInfo;
- (void)updateCurrentArtist:(NSString*)artist Song:(NSString*)song;
- (void)updateAppStatus:(NSString*)status;
- (void)addMetacaster:(NSString*)name;


@end
