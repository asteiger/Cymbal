#import "MediaInfoSupplier.h"
#import "MCGrowlController.h"
#import "Server.h"
#import "Connection.h"

@interface MetacastAppDelegate : NSObject <NSApplicationDelegate> {
    Server *server;
	Connection *connection;
    
	MCGrowlController *growlController;
	MediaInfoSupplier *mediaController;
    
    NSMenu *statusMenu;
    NSStatusItem *statusItem;
}

@property (nonatomic, retain) IBOutlet NSMenu *statusMenu;
@property (nonatomic, retain) IBOutlet MediaInfoSupplier *mediaController;

- (IBAction)toggleBroadcast:(id)sender;
- (BOOL)validateMenuItem:(NSMenuItem *)menuItem;

@end
