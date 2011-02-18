//
//  MCNotificationController.m
//  Djinn
//
//  Created by Ashley Steigerwalt on 1/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MCGrowlController.h"

@implementation MCGrowlController

+ (void)postNotificationWithSong:(MCSongData*)songData {
	[GrowlApplicationBridge notifyWithTitle:songData.artist
								description:songData.songTitle
						   notificationName:@"Song Information"
								   iconData:nil
								   priority:0
								   isSticky:NO
							   clickContext:nil];
}

+ (void)postNotificationWithTitle:(NSString*)title Description:(NSString*)description NotificationName:(NSString*)notificationName {
	[GrowlApplicationBridge notifyWithTitle:title
								description:description
						   notificationName:notificationName
								   iconData:nil
								   priority:0
								   isSticky:NO
							   clickContext:nil];
}

+ (void)postBroadcastEnabledNotificationWithState:(int)state {
	NSString *stateMessage = state == NSOnState ? @"Broadcast Enabled" : @"Broadcast Disabled";
	
	[GrowlApplicationBridge notifyWithTitle:@"Djinn"
								description:stateMessage
						   notificationName:@"Broadcast Enabled Status"
								   iconData:nil
								   priority:0
								   isSticky:NO
							   clickContext:nil];
}

+ (void)postConnectedToBroadcasterWithName:(NSString*)name {
	NSString *message = [NSString stringWithFormat:@"Listening to %@", name];
	
	[GrowlApplicationBridge notifyWithTitle:@"Connected"
								description:message
						   notificationName:@"Connect to Broadcaster"
								   iconData:nil
								   priority:0
								   isSticky:NO
							   clickContext:nil];
}

@end
