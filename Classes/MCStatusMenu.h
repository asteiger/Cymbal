//
//  MCStatusMenu.h
//  MetaCast
//
//  Created by Ashley Steigerwalt on 1/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MCStatusMenu : NSObject {
	NSStatusItem *statusItem;
	
	NSMenuItem *appStatus;
}

+ (MCStatusMenu*)sharedMCStatusMenu;

- (void)updateAppStatus:(NSString*)status;
- (void)addMetacaster:(NSString*)name;


@end
