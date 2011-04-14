#import "MediaController.h"
#import "MCGrowlController.h"
#import "Server.h"
#import "Connection.h"

@class MediaState;

@interface MetacastAppDelegate : NSObject <NSApplicationDelegate> {
    NSString *appState;
    
    Server *server;
	Connection *connection;
    
	MCGrowlController *growlController;
	MediaController *mediaListener;
    
    NSMenu *statusMenu;
    NSStatusItem *statusItem;
}

@property (nonatomic, retain) NSString *appState;
@property (nonatomic, retain) IBOutlet NSMenu *statusMenu;
@property (nonatomic, retain) IBOutlet MediaController *mediaListener;

- (IBAction)toggleBroadcast:(id)sender;
- (BOOL)validateMenuItem:(NSMenuItem *)menuItem;

@end
