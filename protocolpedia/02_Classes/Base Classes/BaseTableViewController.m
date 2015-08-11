//
//  BaseTableViewController.m
//  ProtocolPedia
//
//   7/12/10.


#import "BaseTableViewController.h"



@implementation BaseTableViewController

@synthesize menuItems;
@synthesize appDelegate;
@synthesize tableViewOutlet;
@synthesize navbarView;
@synthesize navbarTitle;

- (void)viewDidLoad {
    [super viewDidLoad];
	self.appDelegate = (PPAppDelegate*)[[UIApplication sharedApplication]delegate];
	
	// set colors for navigation bar and background
//	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
//	self.view.backgroundColor = [UIColor colorWithRed:0.15 green:0.28 blue:0.47 alpha:1.0];
//	self.tableViewOutlet.backgroundColor = [UIColor colorWithRed:0.15 green:0.28 blue:0.47 alpha:1.0];	
	UIColor *myColor = [UIColor colorWithRed:([[self.appDelegate.settings objectForKey:@"Red"] floatValue]/255.0) green:([[self.appDelegate.settings objectForKey:@"Green"] floatValue]/255.0) blue:([[self.appDelegate.settings objectForKey:@"Blue"] floatValue]/255.0) alpha:1.0];
	UIColor *myTintColor = [UIColor colorWithRed:([[self.appDelegate.settings objectForKey:@"TintRed"] floatValue]/255.0) green:([[self.appDelegate.settings objectForKey:@"TintGreen"] floatValue]/255.0) blue:([[self.appDelegate.settings objectForKey:@"TintBlue"] floatValue]/255.0) alpha:1.0];
	self.navigationController.navigationBar.tintColor = myTintColor;
	self.view.backgroundColor = myColor;
	self.tableViewOutlet.backgroundColor = myColor;	
	
	
	// set back button for this view
	UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
	self.navigationItem.backBarButtonItem = backBarItem;
	
    [self.tableViewOutlet setBackgroundView:nil];

	
	NSNotificationCenter *statusMessageNotificationCenter = [NSNotificationCenter defaultCenter];
	[statusMessageNotificationCenter addObserver:self selector:@selector(statusMessage:) name:@"NavbarStatusMessage" object:nil];
}


-(void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:NO];
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 200, 40)];
	titleLabel.numberOfLines = 2;
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.lineBreakMode = UILineBreakModeWordWrap;
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.font = [UIFont boldSystemFontOfSize:18];
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.adjustsFontSizeToFitWidth = YES;
	titleLabel.minimumFontSize = 12;
	titleLabel.text = self.navbarTitle;
	self.navbarView = titleLabel;
	[self.navigationController.navigationBar addSubview:self.navbarView];
	
}


-(void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:NO];
	[self.navbarView removeFromSuperview];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}





@end

