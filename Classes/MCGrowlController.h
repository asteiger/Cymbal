//
//  MCNotificationController.h
//  Djinn
//
//  Created by Ashley Steigerwalt on 1/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MCSongData.h"
#import "Growl.framework/Headers/GrowlApplicationBridge.h"


@interface MCGrowlController : NSObject <GrowlApplicationBridgeDelegate> {

}

+ (void)postNotificationWithSong:(MCSongData*)songData;
+ (void)postNotificationWithTitle:(NSString*)title Description:(NSString*)description NotificationName:(NSString*)notificationName;
+ (void)postBroadcastEnabledNotificationWithState:(int)state;

@end
