//
//  PPAppDelegate.m
//  ProtocolPedia
//


#import "PPAppDelegate.h"
#import "PPHomeIPadViewController.h"

#import "ProtocolCategoriesViewController.h"
#import "SearchProtocolsViewController.h"
#import "FavoriteListViewController.h"
#import "CalculatorListViewController.h"
#import "VideoCategoriesViewController.h"
#import "ForumRootViewController.h"
#import "ColorTestViewController.h"
#import "AboutViewController.h"



#import "PPSplashScreenViewController.h"

#import "PPTabViewController.h"
#import "PPMainViewController.h"

#import <Parse/Parse.h>

#pragma mark -
#pragma mark Private Interface
@interface PPAppDelegate ()

@end

@implementation PPAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize viewDeckController;
@synthesize isAtLeast7;


@synthesize settings;
@synthesize username;
@synthesize password;
@synthesize sessionId;
@synthesize changeFavoriteProtocol;
@synthesize loginTime;
@synthesize addTopic;
@synthesize addThread;
@synthesize requestingObject;

@synthesize changingFavorite;
@synthesize searchResultfavoritesChanged;
@synthesize favoritesChanged;
@synthesize protocolListfavoritesChanged;
@synthesize addingTopic;
@synthesize currentlyDownloading;
@synthesize loggedIn;

@synthesize session = _session;

#define AdMob_ID @"ca-app-pub-4786348679245811/4886726460" 

- (UIColor *) iOS7BarColor{
    return [UIColor colorWithRed:41.0/255.0 green:112.0/255.0 blue:175.0/255.0 alpha:1.0];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:self.session];
}
-(void)addView
{
    float wDevice = 320;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        wDevice = 768;
    }
    else{
        wDevice = 320;
    }
    
	overlayView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, wDevice, [UIScreen mainScreen].bounds.size.height)];
	[overlayView setBackgroundColor:[UIColor blackColor]];
	[overlayView setAlpha:.6];
	
	indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	indicator.center = CGPointMake(wDevice/2, [UIScreen mainScreen].bounds.size.height/2);
	[overlayView addSubview:indicator];
	[indicator startAnimating];
	[self.window addSubview:overlayView];

}
-(void)pushOverLayView
{
    [self.window bringSubviewToFront:overlayView];
    
    float wDevice = 320;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        wDevice = 768;
    }
    else{
        wDevice = 320;
    }
    
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        [overlayView setFrame:CGRectMake(0, 0, 448, 1004)];
//    }
//    else{
        [overlayView setFrame:CGRectMake(0, 0, wDevice, [UIScreen mainScreen].bounds.size.height)];
//    }
}
-(void)popOverLayView
{
    float wDevice = 320;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        wDevice = 768;
    }
    else{
        wDevice = 320;
    }
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        [overlayView setFrame:CGRectMake(768, 0, 448, 1004)];
//    }
//    else{
        [overlayView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, wDevice, [UIScreen mainScreen].bounds.size.height)];
//    }
}

//- (BOOL)fileManager:(NSFileManager *)fileManager shouldCopyItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath {
//	NSLog(@"YES -shouldCopyItemAtPath");
//	return YES;
//}

- (BOOL)fileManager:(NSFileManager *)fileManager shouldProceedAfterError:(NSError *)error copyingItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath {
    //	NSLog(@"YES -shouldProceedAfterError - copyingItemAtPath");
	return YES;
}

- (BOOL)fileManager:(NSFileManager *)fileManager shouldProceedAfterError:(NSError *)error removingItemAtPath:(NSString *)path {
    //	NSLog(@"YES -shouldProceedAfterError - removingItemAtPath");
	return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
	fileManager.delegate = self;
	
	NSArray *userfiles = [NSArray arrayWithObjects:@"Settings.plist",@"ProtocolPedia.db",@"PCRMastermixValues.plist",@"Resuspension.plist",@"Dilution.plist",@"Molarity.plist",nil];
	BOOL success;
	NSString *path;
	for (id item in userfiles) {
		path= [GlobalMethods dataFilePathofDocuments:item];
		success = [fileManager fileExistsAtPath:path];
		if(!success){[fileManager copyItemAtPath:[GlobalMethods dataFilePathofBundle:item] toPath:path error:nil];}
	}
	
    // Register for Push Notifications
    // ****************************************************************************
    // Uncomment and fill in with your Parse credentials:
    // [Parse setApplicationId:@"your_application_id" clientKey:@"your_client_key"];
    // ****************************************************************************
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [application registerForRemoteNotifications];
    }
    else
    {
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    }
	//////////////////////////////////
    
	// load settings into memory
	NSMutableDictionary *settingsTemp = [[NSMutableDictionary alloc] initWithContentsOfFile:[GlobalMethods dataFilePathofDocuments:@"Settings.plist"]];
	self.settings = settingsTemp;
	
	// initialize properties
	self.currentlyDownloading = NO;
	self.searchResultfavoritesChanged = NO;
	self.favoritesChanged = NO;
	self.protocolListfavoritesChanged = NO;
	self.addingTopic = NO;
	self.loginTime = nil;
	self.username = [NSString string];
	self.password = [NSString string];
	
    
//#warning THIS IS THE GOOD WORK
    
    NSString *version = [[UIDevice currentDevice] systemVersion];
    self.isAtLeast7 = [version floatValue] >= 7.0;
    
    PPSplashScreenViewController *splashScreenViewController = [[PPSplashScreenViewController alloc] initWithNibName:@"PPSplashScreenViewController" bundle:nil];
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:splashScreenViewController];
    
    self.viewDeckController =  [[IIViewDeckController alloc] initWithCenterViewController: self.navigationController];
    
    self.window.rootViewController = self.viewDeckController;
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[PPMainViewController alloc] init]];
//    nav.navigationBarHidden = YES;
//    self.window.rootViewController = nav;
//    self.navigationController = nav;
    
    self.viewDeckController.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
    self.viewDeckController.panningCancelsTouchesInView = YES;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [self.viewDeckController setSizeMode:IIViewDeckViewSizeMode];
        self.viewDeckController.leftSize = 280;
        self.viewDeckController.rightSize = 280;
    }
    
    if (self.isAtLeast7) {
        [[UINavigationBar appearance] setBarTintColor:[self iOS7BarColor]];
        [application setMinimumBackgroundFetchInterval: UIApplicationBackgroundFetchIntervalMinimum];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self.window makeKeyAndVisible];
    
//    [self addView];
    
    
    AbMob = [[GADBannerView alloc]
             initWithFrame:CGRectMake(0.0,
                                      self.window.frame.size.height -
                                      GAD_SIZE_320x50 .height,
                                      GAD_SIZE_320x50 .width,
                                      GAD_SIZE_320x50 .height)];
    
    AbMob.adUnitID = AdMob_ID;
    AbMob.rootViewController = self.viewDeckController;
    [self.window addSubview:AbMob];
    
    GADRequest *r = [[GADRequest alloc] init];
    r.testDevices = @[GAD_SIMULATOR_ID ];
    [AbMob loadRequest:r];
    
    
    
    return YES;
}
// push Notification
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[@"global"];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (error.code == 3010) {
        NSLog(@"Push notifications are not supported in the iOS Simulator.");
    } else {
        // show some alert or otherwise handle the failure to register.
        NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}
///////////////////////////////////////////////////////////////
-(void) changeFavoriteProtocolId:(NSString*)thisProtocolId withChange:(NSString*)thisChange forRequestingObject:(NSString*)thisRequestingObject {
    
	if (self.changingFavorite == NO) {
		self.changingFavorite = YES;
		//NSLog(@"thisChange %@",thisChange);
		self.requestingObject = thisRequestingObject;
        
		self.favoritesChanged = YES;
		self.protocolListfavoritesChanged = YES;
		self.searchResultfavoritesChanged = YES;
		
		
		NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
		[myNotificationCenter addObserver:self selector:@selector(changeFavoriteProtocolComplete:) name:@"ChangeFavoriteProtocol" object:nil];
		
		ChangeFavoriteProtocol *tempChangeFavoriteProtocol = [[ChangeFavoriteProtocol alloc] init];
		self.changeFavoriteProtocol = tempChangeFavoriteProtocol;
		[self.changeFavoriteProtocol changeFavoriteProtocolId:thisProtocolId withChange:thisChange  withSessionId:self.sessionId];
	}
}


-(void) changeFavoriteProtocolComplete:(NSNotification*)notification {
    
	NSNotificationCenter *authenticationCompleteNotificationCenter = [NSNotificationCenter defaultCenter];
	[authenticationCompleteNotificationCenter removeObserver:self name:@"ChangeFavoriteProtocol" object:nil];
    
	if ([[notification object] errorReceived]) {
		[GlobalMethods receivedError:[NSString stringWithFormat:@"%@",[[notification object] errorReceived]]];
	}
	
	[GlobalMethods postNotification:self.requestingObject withObject:[[notification object] errorReceived]];
	self.changingFavorite = NO;
}


-(void) addTopicTo:(NSString*)type withId:(NSString*)thisId withSubject:(NSString*)thisSubject withMessageText:(NSString*)thisMessageText withPhoto:(NSData*)thisPhoto  {
	
	if (self.addingTopic == NO) {
		self.addingTopic = YES;
		NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
		[myNotificationCenter addObserver:self selector:@selector(addTopicComplete:) name:@"AddTopicDelegate" object:nil];
		
		if ([type isEqualToString:@"Topic"]) {
			AddTopic *tempAddTopic = [[AddTopic alloc] init];
			self.addTopic = tempAddTopic;
			[self.addTopic addTopicToThisForumCategory:thisId withSubject:thisSubject withMessageText:thisMessageText withPhoto:thisPhoto withSessionId:self.sessionId];
		} else if ([type isEqualToString:@"Thread"]) {
			AddThread *tempAddThread = [[AddThread alloc] init];
			self.addThread = tempAddThread;
			[self.addThread addTopicToThisForumCategory:thisId withSubject:thisSubject withMessageText:thisMessageText withPhoto:thisPhoto withSessionId:self.sessionId];
		}
	}
}

-(void) addTopicComplete:(NSNotification*)notification {
	//NSLog(@"addTopic received in appdelegate");
    
	NSNotificationCenter *authenticationCompleteNotificationCenter = [NSNotificationCenter defaultCenter];
	[authenticationCompleteNotificationCenter removeObserver:self name:@"AddTopicDelegate" object:nil];
	
	if ([notification object]) {
		[GlobalMethods receivedError:[notification object]];
	}
	
	self.addingTopic = NO;
}

- (void)applicationWillResignActive:(UIApplication *)application{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSString *pathforsettings = [GlobalMethods dataFilePathofDocuments:@"Settings.plist"];
	BOOL ok = [self.settings writeToFile:pathforsettings atomically:YES];
	if (ok != YES) {NSLog(@"savesettings did not save!");}
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    if ([self.loginTime timeIntervalSinceDate:[NSDate date]] > 7100) {
        self.sessionId = nil;
        self.loggedIn = NO;
        self.loginTime = nil;
        [GlobalMethods displayMessage:@"Your login session has timed out"];
    }
    
	
    if (self.loggedIn == YES) {
        if (![GlobalMethods canConnect]) {
            self.sessionId = nil;
            self.loggedIn = NO;
            [GlobalMethods displayMessage:@"You lost connection to server"];
        }
        
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // FBSample logic
    // We need to properly handle activation of the application with regards to SSO
    //  (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
    [FBAppCall handleDidBecomeActiveWithSession:self.session];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSString *pathforsettings = [GlobalMethods dataFilePathofDocuments:@"Settings.plist"];
	BOOL ok = [self.settings writeToFile:pathforsettings atomically:YES];
	if (ok != YES) {NSLog(@"savesettings did not save!");}
	self.sessionId = nil;
	self.username = nil;
	self.password = nil;
	self.loggedIn = NO;
    //// Facebook
    [self.session close];
    
}

@end
