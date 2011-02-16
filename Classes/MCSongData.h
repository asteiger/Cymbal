//
//  MCSongData.h
//  Djinn
//
//  Created by Ashley Steigerwalt on 2/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MCSongData : NSObject {
	NSString *_artist;
	NSString *_songTitle;
}

@property (nonatomic, retain) NSString *artist;
@property (nonatomic, retain) NSString *songTitle;


- (id)initWithArtist:(NSString*)artist SongTitle:(NSString*)songTitle;

@end
