//
//  BaseViewController.m
//  ProtocolPedia
//
//   7/12/10.


#import "BaseViewController.h"



@implementation BaseViewController

@synthesize menuItems;
@synthesize appDelegate;
@synthesize tableViewOutlet;
@synthesize bannerIsVisible;
@synthesize adView;
@synthesize navbarView;
@synthesize navbarTitle;


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.appDelegate = (PPAppDelegate*)[[UIApplication sharedApplication]delegate];
	self.bannerIsVisible = NO;
	[self loadAd];
	
	// set colors for navigation bar and background
	UIColor *myColor = [UIColor colorWithRed:([[self.appDelegate.settings objectForKey:@"Red"] floatValue]/255.0) green:([[self.appDelegate.settings objectForKey:@"Green"] floatValue]/255.0) blue:([[self.appDelegate.settings objectForKey:@"Blue"] floatValue]/255.0) alpha:1.0];
	UIColor *myTintColor = [UIColor colorWithRed:([[self.appDelegate.settings objectForKey:@"TintRed"] floatValue]/255.0) green:([[self.appDelegate.settings objectForKey:@"TintGreen"] floatValue]/255.0) blue:([[self.appDelegate.settings objectForKey:@"TintBlue"] floatValue]/255.0) alpha:1.0];
	self.navigationController.navigationBar.tintColor = myTintColor;
	self.view.backgroundColor = myColor;
	self.tableViewOutlet.backgroundColor = myColor;	
	
	// set back button for this view	
	UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
	self.navigationItem.backBarButtonItem = backBarItem;
	
	NSNotificationCenter *statusMessageNotificationCenter = [NSNotificationCenter defaultCenter];
	[statusMessageNotificationCenter addObserver:self selector:@selector(statusMessage:) name:@"NavbarStatusMessage" object:nil];

}

-(void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:NO];
//	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 200, 40)];
//	titleLabel.numberOfLines = 2;
//	titleLabel.backgroundColor = [UIColor clearColor];
//	titleLabel.lineBreakMode = UILineBreakModeWordWrap;
//	titleLabel.textColor = [UIColor whiteColor];
//	titleLabel.font = [UIFont boldSystemFontOfSize:18];
//	titleLabel.textAlignment = UITextAlignmentCenter;
//	titleLabel.adjustsFontSizeToFitWidth = YES;
//	titleLabel.minimumFontSize = 12;
//	titleLabel.text = self.navbarTitle;
//	self.navbarView = titleLabel;
//	[titleLabel release];
//	[self.navigationController.navigationBar addSubview:self.navbarView];

}


-(void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:NO];
	[self.navbarView removeFromSuperview];
}

-(void) viewDidUnload {
	  [super viewDidUnload];
    if (self.adView) {
        adView.delegate = nil;
        self.adView = nil;
	}
}

-(void) loadAd {
	Class classAdBannerView = NSClassFromString(@"ADBannerView");
	 if (classAdBannerView) {
		//if (self.adView == nil) {
         
         	ADBannerView *tempAdView = [[classAdBannerView alloc] initWithFrame:CGRectZero];
         
		// tempAdView.requiredContentSizeIdentifiers = [NSSet setWithObjects:
		//										  ADBannerContentSizeIdentifier320x50,
         //                                         ADBannerContentSizeIdentifier480x32,
		//										  nil];
		 
		 // Set the current size based on device orientation
		 tempAdView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
         tempAdView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
         
         tempAdView.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1.0];
		 tempAdView.delegate = self;
		 
		// tempAdView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
		 
		 // Set initial frame to be offscreen
		 //tempAdView.frame = CGRectMake((self.view.frame.size.width - 320)/2, 0.0, 320, 50);
		 
		 // add adView to View
		 self.adView = tempAdView;
         [self.view addSubview:self.adView];
		 	
			//self.adView = tempAdView;
			//[tempAdView release];
//			tempAdView.delegate = self;
//			[tempAdView setCurrentContentSizeIdentifier:ADBannerContentSizeIdentifier320x50];
//			tempAdView.frame = CGRectMake(0, -50, 320, 50);
//			[self.view addSubview:tempAdView];
//			[tempAdView release];
		//}
	}

}

-(void) statusMessage:(NSNotification*)notification {
		self.navigationItem.prompt = [notification object];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}



#pragma mark ADBannerViewDelegate methods

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    banner.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1.0];
	if (!self.bannerIsVisible) {
		[UIView beginAnimations:@"animateAdBannerOn" context:NULL];
		// banner is invisible now and moved out of the screen on 50 px
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            banner.frame = CGRectMake(0, 0, 768, banner.frame.size.height);
            self.tableViewOutlet.frame = CGRectOffset(self.tableViewOutlet.frame, 0, 50);
        }
        else{
            banner.frame = CGRectMake(0, 0, 320, banner.frame.size.height);
            self.tableViewOutlet.frame = CGRectOffset(self.tableViewOutlet.frame, 0, 50);
        }
		[UIView commitAnimations];
		self.bannerIsVisible = YES;
	}
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    if (self.bannerIsVisible) {
		[UIView beginAnimations:@"animateAdBannerOff" context:NULL];
		// banner is visible and we move it out of the screen, due to connection issue
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            banner.frame = CGRectOffset(banner.frame, 0, -50);
            self.tableViewOutlet.frame = CGRectOffset(self.tableViewOutlet.frame, 0, -50);
        }
        else{
            banner.frame = CGRectOffset(banner.frame, 0, -50);
            self.tableViewOutlet.frame = CGRectOffset(self.tableViewOutlet.frame, 0, -50);
        }
		[UIView commitAnimations];
		self.bannerIsVisible = NO;
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation ==UIInterfaceOrientationPortraitUpsideDown);
}


-(BOOL) shouldAutorotate{
    return YES;
}

-(NSUInteger) supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
	NSLog(@"ForumRootViewController willLeaveApplication");
    return YES;
}

-(void)bannerViewActionDidFinish:(ADBannerView *)banner {
	NSLog(@"ForumRootViewController bannerViewActionDidFinish");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}







@end
