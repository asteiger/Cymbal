#import "MediaInfoSupplier.h"
#import "MCGrowlController.h"
#import "Server.h"
#import "Connection.h"
#import "Browser.h"

@interface MetacastAppDelegate : NSObject <NSApplicationDelegate> {
    Server *server;
	Connection *connection;
    Browser *browser;
    
	MCGrowlController *growlController;
	MediaInfoSupplier *mediaInfoSupplier;
    
    NSStatusItem *statusItem;
    NSMenu *statusMenu;
    NSMenu *listenersMenu;
    NSMenu *metacastersMenu;
    
    NSMenuItem *noListeners;
    NSMenuItem *noMetacasters;
}

@property (nonatomic, readonly) Browser *browser;
@property (nonatomic, retain) IBOutlet NSMenu *statusMenu;
@property (nonatomic, retain) IBOutlet NSMenu *listenersMenu;
@property (nonatomic, retain) IBOutlet NSMenu *metacastersMenu;
@property (nonatomic, retain) IBOutlet MediaInfoSupplier *mediaInfoSupplier;
@property (nonatomic, retain) IBOutlet NSMenuItem *noListeners;
@property (nonatomic, retain) IBOutlet NSMenuItem *noMetacasters;

- (IBAction)toggleBroadcast:(id)sender;
- (BOOL)validateMenuItem:(NSMenuItem *)menuItem;

- (void)availableServiceAdded:(NSNotification*)notification;
- (void)availableServiceRemoved:(NSNotification*)notification;
- (BOOL)connectToMetacasterWithName:(NSString*)name;
- (void)didSelectMetacaster:(NSMenuItem*)sender;

- (void)listenerConnected:(NSNotification*)notification;
- (void)listenerDisonnected:(NSNotification*)notification;

@end
