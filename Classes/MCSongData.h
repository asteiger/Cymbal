
@interface MCSongData : NSObject {
	NSString *_artist;
	NSString *_songTitle;
	NSString *_album;
}

@property (nonatomic, retain) NSString *artist;
@property (nonatomic, retain) NSString *songTitle;
@property (nonatomic, retain) NSString *album;

+ (MCSongData*)songDataWithArtist:(NSString*)artist SongTitle:(NSString*)songTitle Album:(NSString*)album;

- (id)initWithArtist:(NSString*)artist SongTitle:(NSString*)songTitle Album:(NSString*)album;

@end
