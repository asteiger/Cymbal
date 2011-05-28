#import "MediaInfoSupplier.h"
#import "Server.h"
#import "Connection.h"
#import "Browser.h"
#import "PreferencesController.h"

@interface MetacastAppDelegate : NSObject <NSApplicationDelegate> {
    Server *server;
	Connection *connection;
    Browser *browser;
    
	MediaInfoSupplier *mediaInfoSupplier;
    
    NSStatusItem *statusItem;
    NSMenu *statusMenu;
    NSMenu *listenersMenu;
    NSMenu *metacastersMenu;
    
    NSMenuItem *noListeners;
    NSMenuItem *noMetacasters;
    
    NSNumber *alwaysNo;
    
    PreferencesController *preferences;
}

@property (nonatomic, readonly) Server *server;
@property (nonatomic, readonly) Browser *browser;
@property (nonatomic, retain) IBOutlet NSMenu *statusMenu;
@property (nonatomic, retain) IBOutlet NSMenu *listenersMenu;
@property (nonatomic, retain) IBOutlet NSMenu *metacastersMenu;
@property (nonatomic, retain) IBOutlet MediaInfoSupplier *mediaInfoSupplier;
@property (nonatomic, retain) IBOutlet NSMenuItem *noListeners;
@property (nonatomic, retain) IBOutlet NSMenuItem *noMetacasters;
@property (nonatomic, retain) NSNumber *alwaysNo;

- (IBAction)toggleBroadcast:(id)sender;
- (IBAction)toggleAutoconnect:(id)sender;
- (IBAction)toggleShowDesktopNotifications:(id)sender;
- (BOOL)validateMenuItem:(NSMenuItem *)menuItem;

- (void)availableServiceAdded:(NSNotification*)notification;
- (void)availableServiceRemoved:(NSNotification*)notification;
- (BOOL)connectToMetacasterWithName:(NSString*)name;
- (void)didSelectMetacaster:(NSMenuItem*)sender;

- (void)listenerDisonnected:(NSNotification*)notification;

- (void)receivedItunesNotification:(NSNotification *)mediaNotification;

@end
