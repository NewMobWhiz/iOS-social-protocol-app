//
//  ForumCategoriesViewController.m
//  ProtocolPedia
//
//   7/16/10.


#import "ForumCategoriesViewController.h"
#import "SQLiteAccess.h"
#import "TopicsListViewController.h"


@implementation ForumCategoriesViewController

@synthesize parentId;
@synthesize viewHeader;


#pragma mark -
#pragma mark View lifecycle




- (void)viewDidLoad {
    [super viewDidLoad];
	self.menuItems = (NSMutableArray*)[SQLiteAccess selectManyRowsWithSQL:[NSString stringWithFormat:@"SELECT * FROM Categories WHERE ParentId = %@ AND CategoryType = \"Topics\"",self.parentId]];

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



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
		NSString *tempString = [NSString stringWithFormat:@"%@ topic, %@",[[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"NumberOfItems"],[[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"Description"]];
		cell.detailTextLabel.text = tempString;
	} else {
		NSString *tempString = [NSString stringWithFormat:@"%@ topics, %@",[[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"NumberOfItems"],[[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"Description"]];
		cell.detailTextLabel.text = tempString;
	}
    
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
//        TopicsListViewController *topicsListViewController = [[TopicsListViewController alloc] initWithNibName:@"TopicsListViewController" bundle:nil];
//		topicsListViewController.navbarTitle = [[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"Name"];
//		topicsListViewController.title = nil;
//		topicsListViewController.categoryId = [[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"CategoryId"];
//        topicsListViewController.view.frame = CGRectMake(448, 0, 448, 1004);
//        [self.view addSubview:topicsListViewController.view];
//        
//        [UIView animateWithDuration:0.3 animations:^{
//            topicsListViewController.view.frame = CGRectMake(0, 0, 448, 1004);
//        }];
//    }
//    else{
        TopicsListViewController *topicsListViewController = [[TopicsListViewController alloc] initWithNibName:@"TopicsListViewController" bundle:nil];
		topicsListViewController.navbarTitle = [[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"Name"];
		topicsListViewController.title = nil;
		topicsListViewController.categoryId = [[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"CategoryId"];
		[[self navigationController] pushViewController:topicsListViewController animated:YES];
		//    }
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

