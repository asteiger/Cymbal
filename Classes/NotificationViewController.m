//
//  NotificationViewController.m
//  Cymbal
//
//  Created by Ashley Steigerwalt on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NotificationViewController.h"


@implementation NotificationViewController

@synthesize titleLine = _titleLine;
@synthesize subjectLine1 = _subjectLine1;
@synthesize subjectLine2 = _subjectLine2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (([super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {

    }
    
    return self;
}

- (void)dealloc
{
    self.titleLine = nil;
    self.subjectLine1 = nil;
    self.subjectLine2 = nil;
    [super dealloc];
}

@end
