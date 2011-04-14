#import "MediaController.h"
#import "MCSongData.h"
#import "iTunes.h"
#import "Server.h"

@interface LocalMediaController : MediaController {
    Server *_server;
    iTunesApplication *_iTunes;

}

- (id)initWithServer:(Server*)server;
- (void)receivedItunesNotification:(NSNotification *)mediaNotification;

@end
