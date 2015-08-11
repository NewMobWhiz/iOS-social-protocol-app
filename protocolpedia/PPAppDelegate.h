//
//  PPAppDelegate.h
//  ProtocolPedia
//


#import <UIKit/UIKit.h>
#import "ChangeFavoriteProtocol.h"
#import "AddTopic.h"
#import "AddThread.h"
#import "GHMenuViewController.h"
#import "GHRevealViewController.h"
#import "GHMenuCell.h"

#import "IIViewDeckController.h"
#import "GADBannerView.h"

#import <FacebookSDK/FacebookSDK.h>

typedef void (^RevealBlock)();

@interface PPAppDelegate : UIResponder <UIApplicationDelegate>{
    NSMutableDictionary *settings;
	NSString *username;
	NSString *password;
	NSString *sessionId;
	NSDate *loginTime;
	ChangeFavoriteProtocol *changeFavoriteProtocol;
	AddTopic *addTopic;
	AddThread *addThread;
	NSString *requestingObject;
	
	BOOL changingFavorite;
	BOOL searchResultfavoritesChanged;
	BOOL favoritesChanged;
	BOOL protocolListfavoritesChanged;
	BOOL addingTopic;
	BOOL currentlyDownloading;
	BOOL loggedIn;
	
	UIView *overlayView;
	UIActivityIndicatorView *indicator;
    
    GADBannerView *AbMob;
}

@property (nonatomic, strong) GHRevealViewController *revealController;
@property (nonatomic, strong) GHMenuViewController *menuController;

@property (nonatomic, retain) NSMutableDictionary *settings;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *sessionId;
@property (nonatomic, retain) ChangeFavoriteProtocol *changeFavoriteProtocol;
@property (nonatomic, retain) NSDate *loginTime;
@property (nonatomic, retain) AddTopic *addTopic;
@property (nonatomic, retain) AddThread *addThread;
@property (nonatomic, retain) NSString *requestingObject;
@property (nonatomic, assign) BOOL changingFavorite;
@property (nonatomic, assign) BOOL searchResultfavoritesChanged;
@property (nonatomic, assign) BOOL favoritesChanged;
@property (nonatomic, assign) BOOL protocolListfavoritesChanged;
@property (nonatomic, assign) BOOL currentlyDownloading;
@property (nonatomic, assign) BOOL addingTopic;
@property (nonatomic, assign) BOOL loggedIn;


//#warning THIS IS THE GOOD WORK

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (nonatomic, strong) UINavigationController * navigationController;
@property (nonatomic, strong) IIViewDeckController *viewDeckController;
@property BOOL isAtLeast7;

@property (strong, nonatomic) FBSession *session;


-(void) changeFavoriteProtocolId:(NSString*)thisProtocolId withChange:(NSString*)thisChange forRequestingObject:(NSString*)thisRequestingObject;
-(void) changeFavoriteProtocolComplete:(NSNotification*)notification;
-(void) addTopicTo:(NSString*)type withId:(NSString*)thisId withSubject:(NSString*)thisSubject withMessageText:(NSString*)thisMessageText withPhoto:(NSData*)thisPhoto;
-(void) addTopicComplete:(NSNotification*)notification;
-(void)pushOverLayView;
-(void)popOverLayView;

@end
