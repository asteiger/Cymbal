//
//  NotificationViewController.h
//  Cymbal
//
//  Created by Ashley Steigerwalt on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NotificationViewController : NSViewController {
    NSString *_titleLine;
    NSString *_subjectLine1;
    NSString *_subjectLine2;
}

@property (nonatomic, retain) IBOutlet NSString *titleLine;
@property (nonatomic, retain) IBOutlet NSString *subjectLine1;
@property (nonatomic, retain) IBOutlet NSString *subjectLine2;

@end
