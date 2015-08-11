//
//  ForumRootViewController.m
//  ProtocolPedia
//
//   7/16/10.


#import "ForumRootViewController.h"
#import "ForumCategoriesViewController.h"
#import "SQLiteAccess.h"
#import "iAd/iAd.h"

#import <QuartzCore/QuartzCore.h>

@implementation ForumRootViewController

@synthesize getForumDiscussions;


#pragma mark -
#pragma mark View lifecycle

- (void)revealSidebar {
	_revealBlock();
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withRevealBlock:(RevealBlock)revealBlock{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _revealBlock = [revealBlock copy];
        
        float wDevice = 320;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            wDevice = 768;
        }
        else{
            wDevice = 320;
        }
        
        self.navigationController.navigationBarHidden = YES;
        viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wDevice, 50)];
        viewHeader.backgroundColor = [UIColor colorWithRed:46.0/255 green:133.0/255 blue:189.0/255 alpha:1.0];
        [self.view addSubview:viewHeader];
        
        UILabel *lb1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, wDevice, 50)];
        lb1.textColor = [UIColor whiteColor];
        lb1.backgroundColor = [UIColor clearColor];
        lb1.font = [UIFont fontWithName:@"Arial" size:18];
        lb1.text = @"Forum";
        lb1.textAlignment = UITextAlignmentCenter;
        [viewHeader addSubview:lb1];
        
        UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 46, 40)];
        [btnBack setImage:[UIImage imageNamed:@"icn_menu_main.png"] forState:UIControlStateNormal];
        [btnBack addTarget:self action:@selector(revealSidebar) forControlEvents:UIControlEventTouchUpInside];
        [viewHeader addSubview:btnBack];
        
        UIButton *btnUpdate = [[UIButton alloc] initWithFrame:CGRectMake(wDevice - 80, 10, 70, 30)];
        [btnUpdate setTitle:@"Update" forState:UIControlStateNormal];
        btnUpdate.titleLabel.font = [UIFont fontWithName:@"Arial" size:12];
        [btnUpdate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnUpdate addTarget:self action:@selector(getForumDiscussionsMethod:) forControlEvents:UIControlEventTouchUpInside];
        btnUpdate.layer.borderWidth = 1;
        btnUpdate.layer.borderColor = [UIColor whiteColor].CGColor;
        btnUpdate.layer.cornerRadius = 4;
        [viewHeader addSubview:btnUpdate];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	self.navbarTitle = @" Forum";
	self.navigationItem.title = nil;
	
	// set update Forum button for this view	
	UIBarButtonItem *updateForumBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStyleBordered target:self action:@selector(getForumDiscussionsMethod:)];
	self.navigationItem.rightBarButtonItem = updateForumBarItem;
	
    [self.tableViewOutlet setBackgroundView:nil];

}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	self.menuItems = (NSMutableArray*)[SQLiteAccess selectManyRowsWithSQL:@"SELECT * FROM Categories WHERE ParentId = 0 AND CategoryType = \"Topics\""];
	[self.tableViewOutlet reloadData];
    
    UIColor *myColor = [UIColor colorWithRed:([[self.appDelegate.settings objectForKey:@"Red"] floatValue]/255.0) green:([[self.appDelegate.settings objectForKey:@"Green"] floatValue]/255.0) blue:([[self.appDelegate.settings objectForKey:@"Blue"] floatValue]/255.0) alpha:1.0];
    UIColor *myTintColor = [UIColor colorWithRed:([[self.appDelegate.settings objectForKey:@"TintRed"] floatValue]/255.0) green:([[self.appDelegate.settings objectForKey:@"TintGreen"] floatValue]/255.0) blue:([[self.appDelegate.settings objectForKey:@"TintBlue"] floatValue]/255.0) alpha:1.0];
    self.navigationController.navigationBar.tintColor = myTintColor;
    self.view.backgroundColor = myColor;
    viewHeader.backgroundColor = myTintColor;
    self.tableViewOutlet.backgroundColor = myColor;
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
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


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.menuItems count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = [[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"Name"];
	if ([[[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"NumberOfItems"] isEqualToString:@"1"]) {
		NSString *tempString = [NSString stringWithFormat:@"%@ catagory",[[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"NumberOfItems"]]; //,[[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"Description"]];
		cell.detailTextLabel.text = tempString;
	} else {
		NSString *tempString = [NSString stringWithFormat:@"%@ catagories",[[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"NumberOfItems"]]; //,[[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"Description"]];
		cell.detailTextLabel.text = tempString;
	}
	
	cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"Name"]]];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
    
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        ForumCategoriesViewController *forumCategoriesViewController = [[ForumCategoriesViewController alloc] initWithNibName:@"ForumCategoriesViewController" bundle:nil];
//        forumCategoriesViewController.navbarTitle = @"Forum";
//        forumCategoriesViewController.title = nil;
//        forumCategoriesViewController.parentId = [[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"CategoryId"];
//        forumCategoriesViewController.view.frame = CGRectMake(448, 0, 448, 1004);
//        forumCategoriesViewController.view.tag = 999;
//        [self.view addSubview:forumCategoriesViewController.view];
//        
//        [UIView animateWithDuration:0.3 animations:^{
//            forumCategoriesViewController.view.frame = CGRectMake(0, 0, 448, 1004);
//        }];
//    }
//    else{
        ForumCategoriesViewController *forumCategoriesViewController = [[ForumCategoriesViewController alloc] initWithNibName:@"ForumCategoriesViewController" bundle:nil];
        forumCategoriesViewController.navbarTitle = @"Forum";
        forumCategoriesViewController.title = nil;
        forumCategoriesViewController.parentId = [[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"CategoryId"];
        [[self navigationController] pushViewController:forumCategoriesViewController animated:YES];
    
//    }
	
}

-(void)closeSubView{
    if ([self.view viewWithTag:999]) {
        UIView *v = [self.view viewWithTag:999];
        [v removeFromSuperview];
        
        v = nil;
    }
}


-(void) getForumDiscussionsMethod:(id)sender {

	if (self.appDelegate.loggedIn == YES) {
		if ((self.appDelegate.changingFavorite == NO) &&
			(self.appDelegate.addingTopic == NO) &&
			(self.appDelegate.currentlyDownloading == NO)) {

			@autoreleasepool {
			NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
			[myNotificationCenter addObserver:self selector:@selector(getForumDiscussionsComplete:) name:@"GetForumDiscussions" object:nil];
			
			GetForumDiscussions *tempGetForumDiscussions = [[GetForumDiscussions alloc] init];
			self.getForumDiscussions = tempGetForumDiscussions;
			[self.getForumDiscussions getMethodNow];	
			
			}
		}
	} else {
		[GlobalMethods displayMessage:@"You must be logged in to update forums"];
	}
	
}


-(void) getForumDiscussionsComplete:(NSNotification *)notification {
	@autoreleasepool {NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
	[myNotificationCenter removeObserver:self name:@"GetForumDiscussions" object:nil];
	if ([[notification object] errorReceived]) {
		[GlobalMethods receivedError:[[notification object] errorReceived]];
	} else {
		[GlobalMethods postNotification:@"AddTopic" withObject:nil];
		[GlobalMethods displayMessage:@"Forum Update Complete"];
	}
	}

}	




#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}





@end

