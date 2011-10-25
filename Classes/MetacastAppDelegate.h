#import "MediaInfoSupplier.h"
#import "Server.h"
#import "Browser.h"
#import "PreferencesController.h"
#import "RdioPoller.h"
#import "SpotifyPoller.h"

@interface MetacastAppDelegate : NSObject <NSApplicationDelegate> {
    Server *server;
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
    
    RdioPoller *rdioPoller;
    SpotifyPoller *spotifyPoller;
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
@property (nonatomic, retain) RdioPoller *rdioPoller;
@property (nonatomic, retain) SpotifyPoller *spotifyPoller;

- (IBAction)toggleBroadcast:(id)sender;
- (IBAction)toggleShowDesktopNotifications:(id)sender;
- (IBAction)toggleRunAtLogin:(id)sender;
- (BOOL)validateMenuItem:(NSMenuItem *)menuItem;

- (void)availableBroadcasterAdded:(NSNotification*)notification;
- (void)availableBroadcasterRemoved:(NSNotification*)notification;

- (void)receivedItunesNotification:(NSNotification *)mediaNotification;

- (void)follow:(NSString*)shareName;

@end
