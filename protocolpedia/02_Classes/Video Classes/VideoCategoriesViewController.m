//
//  VideoCategoriesViewController.m
//  ProtocolPedia
//
//   7/16/10.


#import "VideoCategoriesViewController.h"
#import "SQLiteAccess.h"
#import "VideoListViewController.h"


@implementation VideoCategoriesViewController

@synthesize videoCounts;


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
        lb1.text = @"Video Categories";
        lb1.textAlignment = UITextAlignmentCenter;
        [viewHeader addSubview:lb1];
        
        UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 46, 40)];
        [btnBack setImage:[UIImage imageNamed:@"icn_menu_main.png"] forState:UIControlStateNormal];
        [btnBack addTarget:self action:@selector(revealSidebar) forControlEvents:UIControlEventTouchUpInside];
        [viewHeader addSubview:btnBack];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navbarTitle = @"Video Categories";
	self.navigationItem.title = nil;
    [self.tableViewOutlet setBackgroundView:nil];
	
//	[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(manuallyReloadData) userInfo:nil repeats:NO];
	
}

-(void) manuallyReloadData {
	if (![self.tableViewOutlet numberOfRowsInSection:0] > 0) {
		[self.tableViewOutlet reloadData];
	}


}

-(void)closeSubView{
    if ([self.view viewWithTag:999]) {
        UIView *v = [self.view viewWithTag:999];
        [v removeFromSuperview];
        v = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	self.menuItems = (NSMutableArray*)[SQLiteAccess selectManyRowsWithSQL:[NSString stringWithFormat:@"SELECT * FROM Categories WHERE CategoryType = \"Video\" ORDER BY \"Name\""]];
	NSMutableArray *tempVideoCounts = [[NSMutableArray alloc]  initWithCapacity:[self.menuItems count]];
	self.videoCounts = tempVideoCounts;
	for (int v = 0; v < [self.menuItems count]; v++) {
		NSString *count = [SQLiteAccess selectOneValueSQL:[NSString stringWithFormat:@"SELECT count(*) FROM Videos WHERE CategoryId = %@",[[self.menuItems objectAtIndex:v]objectForKey:@"CategoryId"]]];
		[self.videoCounts addObject:count];
	}
	[self.tableViewOutlet reloadData];
    
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
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ videos",[self.videoCounts objectAtIndex:indexPath.row]];
	cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"Name"]]];
	NSLog(@"%@",[NSString stringWithFormat:@"%@.png",[[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"Name"]]);
	
//	NSString *countSQL = [NSString stringWithFormat:@"SELECT count(*) FROM Videos WHERE CategoryID = %@",[[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"CategoryId"]];
//	int count = [[SQLiteAccess selectOneValueSQL:countSQL] intValue];
//	int count = [countDict objectForKey:@"count"];
//	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ videos",count];
    
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
	
	
	PPAppDelegate *appDelegateA = (PPAppDelegate*)[[UIApplication sharedApplication]delegate];
	[appDelegateA pushOverLayView];
	
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
	
//	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        VideoListViewController *videoListViewController = [[VideoListViewController alloc] initWithNibName:@"BaseTableViewController" bundle:nil];
//        videoListViewController.navbarTitle = [[menuItems objectAtIndex:indexPath.row] objectForKey:@"Name"];
//        videoListViewController.title = nil;
//        videoListViewController.selectedCategory = [[menuItems objectAtIndex:indexPath.row] objectForKey:@"CategoryId"];
//        videoListViewController.view.tag = 999;
//        videoListViewController.view.frame = CGRectMake(448, 0, 448, 1004);
//        [self.view addSubview:videoListViewController.view];
//        
//        [UIView animateWithDuration:0.3 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
//            videoListViewController.view.frame = CGRectMake(0, 0, 448, 1004);
//        } completion:^(BOOL finished) {
//            
//        }];
//    }
//    else{
        VideoListViewController *videoListViewController = [[VideoListViewController alloc] initWithNibName:@"BaseTableViewController" bundle:nil];
        videoListViewController.navbarTitle = [[menuItems objectAtIndex:indexPath.row] objectForKey:@"Name"];
        videoListViewController.title = nil;
        videoListViewController.selectedCategory = [[menuItems objectAtIndex:indexPath.row] objectForKey:@"CategoryId"];
        //NSLog(@"[[menuItems objectAtIndex:indexPath.row] objectForKey:@\"CategoryId\"]%@",[[menuItems objectAtIndex:indexPath.row] objectForKey:@"CategoryId"]);
        
        [[self navigationController] pushViewController:videoListViewController animated:YES];
       
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

