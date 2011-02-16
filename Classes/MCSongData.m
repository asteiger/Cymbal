//
//  MCSongData.m
//  Djinn
//
//  Created by Ashley Steigerwalt on 2/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MCSongData.h"

@implementation MCSongData

@synthesize artist = _artist;
@synthesize songTitle = _songTitle;

- (id)initWithArtist:(NSString*)artist SongTitle:(NSString*)songTitle {
	if (self = [super init]) {
		self.artist = artist;
		self.songTitle = songTitle;
	}
	
	return self;
}

- (void)dealloc {
	self.artist = nil;
	self.songTitle = nil;
	
	[super dealloc];
}

@end
