//
//  TopicsListViewController.m
//  ProtocolPedia
//
//   8/14/10.


#import "TopicsListViewController.h"
#import "SQLiteAccess.h"
#import "AddThreadViewController.h"
#import "AddTopicViewController.h"
#import "ThreadWebViewController.h"


@implementation TopicsListViewController


@synthesize categoryId;


#pragma mark -
#pragma mark View lifecycle



- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.menuItems = [NSMutableArray arrayWithArray:[SQLiteAccess selectManyRowsWithSQL:[NSString stringWithFormat:@"SELECT DiscussionId, ThreadId, Subject FROM Discussions WHERE ParentID = \"0\" AND CategoryID = \"%@\"",self.categoryId]]];

	
	// set add Topic button for this view	
	UIBarButtonItem *addTopicBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Add Topic" style:UIBarButtonItemStyleBordered target:self action:@selector(addTopic:)];
	self.navigationItem.rightBarButtonItem = addTopicBarItem;
	
	NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
	[myNotificationCenter addObserver:self selector:@selector(reloadTable:) name:@"AddTopic" object:nil];

    float wDevice = 320;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        wDevice = 768;
    }
    else{
        wDevice = 320;
    }
    
    viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wDevice, 50)];
    viewHeader.backgroundColor = [UIColor colorWithRed:46.0/255 green:133.0/255 blue:189.0/255 alpha:1.0];
    [self.view addSubview:viewHeader];
    
    UILabel *lb1 = [[UILabel alloc] initWithFrame:CGRectMake(66, 0, wDevice-132, 50)];
    lb1.textColor = [UIColor whiteColor];
    lb1.backgroundColor = [UIColor clearColor];
    lb1.font = [UIFont fontWithName:@"Arial" size:18];
    lb1.text = navbarTitle;
    lb1.textAlignment = UITextAlignmentCenter;
    lb1.lineBreakMode = UILineBreakModeWordWrap;
    lb1.numberOfLines = 2;
    [viewHeader addSubview:lb1];
    
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 46, 40)];
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        [btnBack setImage:[UIImage imageNamed:@"imv_back.png"] forState:UIControlStateNormal];
//    }
//    else{
        [btnBack setImage:[UIImage imageNamed:@"icn_menu_main.png"] forState:UIControlStateNormal];
//    }
    [btnBack addTarget:self action:@selector(revealSidebar) forControlEvents:UIControlEventTouchUpInside];
    [viewHeader addSubview:btnBack];
    
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        viewHeader.frame = CGRectMake(0, 0, 448, 50);
//        lb1.frame = CGRectMake(0, 0, 448, 50);
//    }
    
    [self.tableViewOutlet setBackgroundView:nil];
}

-(void)revealSidebar{
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        [UIView animateWithDuration:0.3 animations:^{
//            self.view.frame = CGRectMake(448, 0, 448, 1004);
//        } completion:^(BOOL finished) {
//            [self.view removeFromSuperview];
//            [self release];
//        }];
//        return;
//    }
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) addTopic:(id)sender {
	if (self.appDelegate.loggedIn == YES) {
		if (self.appDelegate.addingTopic == NO) {
			AddTopicViewController *addTopicViewController = [[AddTopicViewController alloc] initWithNibName:@"AddTopicViewController" bundle:nil];
			addTopicViewController.categoryId = self.categoryId;
			[[self navigationController] pushViewController:addTopicViewController animated:YES];
			
		} else {
			[GlobalMethods displayMessage:@"Currently Adding Topic"];
		}
	} else {
		[GlobalMethods displayMessage:@"You must be logged in to add topic"];
	}
}

-(void) reloadTable:(NSNotification*)notification  {
	self.menuItems = (NSMutableArray*)[SQLiteAccess selectManyRowsWithSQL:[NSString stringWithFormat:@"SELECT DiscussionId, ThreadId, Subject FROM Discussions WHERE ParentID = \"0\" AND CategoryID = \"%@\"",self.categoryId]];
	[self.tableViewOutlet reloadData];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//	if ([self.menuItems count] == 0) {
//		self.menuItems = [NSMutableArray arrayWithArray:[SQLiteAccess selectManyRowsWithSQL:[NSString stringWithFormat:@"SELECT DiscussionId, ThreadId, Subject FROM Discussions WHERE ParentID = \"0\" AND CategoryID = \"%@\"",self.categoryId]]];
//	}
    
    UIColor *myColor = [UIColor colorWithRed:([[self.appDelegate.settings objectForKey:@"Red"] floatValue]/255.0) green:([[self.appDelegate.settings objectForKey:@"Green"] floatValue]/255.0) blue:([[self.appDelegate.settings objectForKey:@"Blue"] floatValue]/255.0) alpha:1.0];
    UIColor *myTintColor = [UIColor colorWithRed:([[self.appDelegate.settings objectForKey:@"TintRed"] floatValue]/255.0) green:([[self.appDelegate.settings objectForKey:@"TintGreen"] floatValue]/255.0) blue:([[self.appDelegate.settings objectForKey:@"TintBlue"] floatValue]/255.0) alpha:1.0];
    viewHeader.backgroundColor = myTintColor;
    self.view.backgroundColor = myColor;
    self.tableViewOutlet.backgroundColor = myColor;
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
	    [super viewWillDisappear:animated];
}

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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
   cell.textLabel.text = [[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"Subject"];
    
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
//        ThreadWebViewController *threadWebViewController = [[ThreadWebViewController alloc] initWithNibName:@"ThreadWebViewController" bundle:nil];
//        threadWebViewController.navbarTitle = [[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"Subject"];
//        threadWebViewController.title = nil;
//        threadWebViewController.threadId = [[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"ThreadId"];
//        threadWebViewController.view.frame = CGRectMake(448, 0, 448, 1004);
//        [self.view addSubview:threadWebViewController.view];
//        
//        [UIView animateWithDuration:0.3 animations:^{
//            threadWebViewController.view.frame = CGRectMake(0, 0, 448, 1004);
//        }];
//    }
//    else{
        ThreadWebViewController *threadWebViewController = [[ThreadWebViewController alloc] initWithNibName:@"ThreadWebViewController" bundle:nil];
        threadWebViewController.threadId = [[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"ThreadId"];
        [[self navigationController] pushViewController:threadWebViewController animated:YES];
        //    }
}




#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
//    
//    [self.menuItems removeAllObjects];
//	[self.tableViewOutlet reloadData];
}

- (void)viewDidUnload {
	NSNotificationCenter *authenticationCompleteNotificationCenter = [NSNotificationCenter defaultCenter];
	[authenticationCompleteNotificationCenter removeObserver:self name:@"AddTopic" object:nil];
}





@end

