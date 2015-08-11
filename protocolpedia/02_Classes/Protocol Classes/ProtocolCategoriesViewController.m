//
//  ProtocolCategoriesViewController.m
//  ProtocolPedia
//
//   7/7/10.


#import "ProtocolCategoriesViewController.h"
#import "SearchProtocolsViewController.h"
#import "ProtocolListViewController.h"
#import "SQLiteAccess.h"
#import "FavoriteListViewController.h"
#import "PPAppDelegate.h"

@implementation ProtocolCategoriesViewController


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
        viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wDevice, 50)] ;
        viewHeader.backgroundColor = [UIColor colorWithRed:46.0/255 green:133.0/255 blue:189.0/255 alpha:1.0];
        [self.view addSubview:viewHeader];
        
        UILabel *lb1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, wDevice, 50)];
        lb1.textColor = [UIColor whiteColor];
        lb1.backgroundColor = [UIColor clearColor];
        lb1.font = [UIFont fontWithName:@"Arial" size:18];
        lb1.text = @"Protocol Categories";
        lb1.textAlignment = UITextAlignmentCenter;
        [viewHeader addSubview:lb1];
        
        UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 46, 40)] ;
        [btnBack setImage:[UIImage imageNamed:@"icn_menu_main.png"] forState:UIControlStateNormal];
        [btnBack addTarget:self action:@selector(revealSidebar) forControlEvents:UIControlEventTouchUpInside];
        [viewHeader addSubview:btnBack];
        
        UIButton *favoritesButton = [[UIButton alloc] initWithFrame:CGRectMake(wDevice - 42, 11, 32, 27)] ;
        [favoritesButton setImage:[UIImage imageNamed:@"heartRedNavButton.png"] forState:UIControlStateNormal];
        [favoritesButton addTarget:self action:@selector(loadFavorites:) forControlEvents:UIControlEventTouchUpInside];
        [viewHeader addSubview:favoritesButton];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    applicationDelegate.viewDeckController.panningMode = IIViewDeckNoPanning;
    
	UIBarButtonItem *favoritesBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"heartRedNavButton.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(loadFavorites:)];
	self.navigationItem.rightBarButtonItem = favoritesBarItem;
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	self.menuItems = (NSMutableArray*)[SQLiteAccess selectManyRowsWithSQL:@"SELECT * FROM Categories WHERE CategoryType = \"Protocol\" AND CategoryId <> \"1\" ORDER BY Name"];
	[self.tableViewOutlet reloadData];
    
    UIColor *myColor = [UIColor colorWithRed:([[self.appDelegate.settings objectForKey:@"Red"] floatValue]/255.0) green:([[self.appDelegate.settings objectForKey:@"Green"] floatValue]/255.0) blue:([[self.appDelegate.settings objectForKey:@"Blue"] floatValue]/255.0) alpha:1.0];
    UIColor *myTintColor = [UIColor colorWithRed:([[self.appDelegate.settings objectForKey:@"TintRed"] floatValue]/255.0) green:([[self.appDelegate.settings objectForKey:@"TintGreen"] floatValue]/255.0) blue:([[self.appDelegate.settings objectForKey:@"TintBlue"] floatValue]/255.0) alpha:1.0];
    viewHeader.backgroundColor = myTintColor;
    self.view.backgroundColor = myColor;
    self.tableViewOutlet.backgroundColor = myColor;
}

-(void) manuallyReloadData:(id)sender {
	if (![self.tableViewOutlet numberOfRowsInSection:0] > 0) {
		[self.tableViewOutlet reloadData];
		//NSLog(@"manuallyReloadData inside if");
	}
	//NSLog(@"manuallyReloadData");

	
	
}


-(void) loadFavorites:(id)sender {
	FavoriteListViewController *favoriteListViewController = [[FavoriteListViewController alloc] initWithNibName:@"BaseTableViewController" bundle:nil];
	favoriteListViewController.navbarTitle = @"Favorite Protocols";
	favoriteListViewController.title = nil;
    favoriteListViewController.typeView = [NSNumber numberWithInt:1];
	[[self navigationController] pushViewController:favoriteListViewController animated:YES];
	
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
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ protocols",[[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"NumberOfItems"]];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
	UIImage *tempImage =  [UIImage imageNamed:[NSString stringWithFormat:@"Cat%@.jpg",[[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"CategoryId"]]];
	
	NSLog(@"%@",[NSString stringWithFormat:@"Cat%@.jpg",[[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"CategoryId"]]);
	NSLog(@"%@",[[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"Name"]);
	
	if (tempImage) {
		cell.imageView.image = tempImage;
	} else {
		tempImage =  [UIImage imageNamed:[NSString stringWithFormat:@"CatImage%@.png",[[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"Name"]]];
		if (tempImage) {
			cell.imageView.image = tempImage;
		} else {
			cell.imageView.image = [UIImage imageNamed:@"questionmark.png"];
		}	
		
	}
    
    return cell;
}

-(void)closeSubView{
    if ([self.view viewWithTag:999]) {
        UIView *v = [self.view viewWithTag:999];
        [v removeFromSuperview];
        v = nil;
    }
}

-(void)goToNextPage
{
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        ProtocolListViewController *protocolListViewController = [[ProtocolListViewController alloc] initWithNibName:@"BaseTableViewController" bundle:nil];
//        protocolListViewController.navbarTitle = [[self.menuItems objectAtIndex:selectedIndex] objectForKey:@"Name"];
//        protocolListViewController.title = nil;
//        protocolListViewController.selectedCategoryId = [[self.menuItems objectAtIndex:selectedIndex] objectForKey:@"CategoryId"];
//        protocolListViewController.view.tag = 999;
//        protocolListViewController.view.frame = CGRectMake(448, 0, 448, 1004);
//        [self.view addSubview:protocolListViewController.view];
//        
//        [UIView animateWithDuration:0.3 animations:^{
//            protocolListViewController.view.frame = CGRectMake(0, 0, 448, 1004);
//        }];
//    }
//    else{
        ProtocolListViewController *protocolListViewController = [[ProtocolListViewController alloc] initWithNibName:@"BaseTableViewController" bundle:nil];
        protocolListViewController.navbarTitle = [[self.menuItems objectAtIndex:selectedIndex] objectForKey:@"Name"];
        protocolListViewController.title = nil;
        protocolListViewController.selectedCategoryId = [[self.menuItems objectAtIndex:selectedIndex] objectForKey:@"CategoryId"];
        [[self navigationController] pushViewController:protocolListViewController animated:YES];
    
//    }
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	selectedIndex = indexPath.row;
	
	
	//PPAppDelegate *appDelegate = (PPAppDelegate*)[[UIApplication sharedApplication]delegate];
	[appDelegate pushOverLayView];
	
	
	[self performSelector:@selector(goToNextPage) withObject:nil afterDelay:.5];

}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end

