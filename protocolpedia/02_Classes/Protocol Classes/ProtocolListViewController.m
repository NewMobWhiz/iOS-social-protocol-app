//
//  ProtocolListViewController.m
//  ProtocolPedia
//
//   7/9/10.


#import "ProtocolListViewController.h"
#import "ProtocolCell.h"
#import "SQLiteAccess.h"
#import "ProtocolWebViewController.h"


@implementation ProtocolListViewController

@synthesize selectedCategoryId;
@synthesize myFavorites;
@synthesize favoriteProtocol;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	NSMutableString *selectProtocols = [NSMutableString string];
	
	[selectProtocols appendString:@"SELECT Protocols.ProtocolId, Protocols.Title, Protocols.NumberOfReviews, Protocols.Stars FROM Protocols "];
	[selectProtocols appendString:@"LEFT JOIN CategoryRelations ON Protocols.ProtocolId = CategoryRelations.ProtocolId "];
	[selectProtocols appendFormat:@"WHERE CategoryRelations.CategoryId = \"%@\" ORDER BY \"CategoryRelations.CategoryOrdering\"",self.selectedCategoryId];
	
//	NSArray *tempArray1 = [[NSMutableArray alloc] initWithArray:[SQLiteAccess selectManyRowsWithSQL:@"SELECT ProtocolId FROM FavoriteProtocols"]];
	//NSLog(@"myFavorites dictionary ProtocolList %@",tempArray1);
	
//	NSMutableArray *tempArray2 = [NSMutableArray array];
//	for (id item in tempArray1) {
//		[tempArray2 addObject:[item objectForKey:@"ProtocolId"]];
//	}
//	self.myFavorites = tempArray2;
//	[tempArray1 release];
	
	NSMutableArray *tempMenuItems = (NSMutableArray*)[[NSMutableArray alloc] initWithArray:[SQLiteAccess selectManyRowsWithSQL:selectProtocols]];
	self.menuItems = tempMenuItems;
	self.appDelegate.protocolListfavoritesChanged = YES;
	
	[appDelegate popOverLayView];
    
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
    
    UILabel *lb1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, wDevice, 50)];
    lb1.textColor = [UIColor whiteColor];
    lb1.backgroundColor = [UIColor clearColor];
    lb1.font = [UIFont fontWithName:@"Arial" size:18];
    lb1.text = navbarTitle;
    lb1.textAlignment = UITextAlignmentCenter;
    [viewHeader addSubview:lb1];
    
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        viewHeader.frame = CGRectMake(0, 0, 448, 50);
//        lb1.frame = CGRectMake(0, 0, 448, 50);
//    }
    
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 46, 40)];
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        [btnBack setImage:[UIImage imageNamed:@"imv_back.png"] forState:UIControlStateNormal];
//    }
//    else{
        [btnBack setImage:[UIImage imageNamed:@"icn_menu_main.png"] forState:UIControlStateNormal];
//    }
    [btnBack addTarget:self action:@selector(revealSidebar) forControlEvents:UIControlEventTouchUpInside];
    [viewHeader addSubview:btnBack];
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

- (void)viewWillAppear:(BOOL)animated  {
	if (self.appDelegate.protocolListfavoritesChanged) {
		//NSLog(@"viewWillAppear favoritesChanged");

		NSArray *tempArray1 = [[NSMutableArray alloc] initWithArray:[SQLiteAccess selectManyRowsWithSQL:@"SELECT ProtocolId FROM FavoriteProtocols"]];

		NSMutableArray *tempArray2 = [NSMutableArray array];
		for (id item in tempArray1) {
			[tempArray2 addObject:[item objectForKey:@"ProtocolId"]];
		}
		self.myFavorites = tempArray2;
		self.appDelegate.protocolListfavoritesChanged = NO;
		
	}
	[self.tableViewOutlet reloadData];
    
    UIColor *myColor = [UIColor colorWithRed:([[self.appDelegate.settings objectForKey:@"Red"] floatValue]/255.0) green:([[self.appDelegate.settings objectForKey:@"Green"] floatValue]/255.0) blue:([[self.appDelegate.settings objectForKey:@"Blue"] floatValue]/255.0) alpha:1.0];
    UIColor *myTintColor = [UIColor colorWithRed:([[self.appDelegate.settings objectForKey:@"TintRed"] floatValue]/255.0) green:([[self.appDelegate.settings objectForKey:@"TintGreen"] floatValue]/255.0) blue:([[self.appDelegate.settings objectForKey:@"TintBlue"] floatValue]/255.0) alpha:1.0];
    viewHeader.backgroundColor = myTintColor;
    self.view.backgroundColor = myColor;
    self.tableViewOutlet.backgroundColor = myColor;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 65;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    ProtocolCell *cell = (ProtocolCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ProtocolCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.protocolName.text = [[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"Title"];

	UIImage *tempImage = [UIImage imageNamed:[NSString stringWithFormat:@"%iStars.png",[[[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"Stars"]intValue]]];
	if(tempImage) {
		cell.starsImageView.image = tempImage;
	} else {
		cell.starsImageView.image = [UIImage imageNamed:@"questionmark.png"];
	}

	[cell.makeFavorite addTarget:self action:@selector(changeFavorite:) forControlEvents:UIControlEventTouchUpInside];
	cell.makeFavorite.tag = indexPath.row;
	if ([self.myFavorites containsObject:[[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"ProtocolId"]]) {
		[cell.makeFavorite setTitle:@"Remove Favorite" forState:UIControlStateNormal];
		[cell.makeFavorite setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
		cell.favorite = YES;
	} else {
		[cell.makeFavorite setTitle:@"Make Favorite" forState:UIControlStateNormal];
		[cell.makeFavorite setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
		cell.favorite = NO;
	}
    return cell;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(ProtocolCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath { 
//	[super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
	cell.protocolName.backgroundColor  = [UIColor clearColor];
//	cell.reviews.backgroundColor  = [UIColor clearColor];
//	cell.reviewsLabel.backgroundColor  = [UIColor clearColor];
	cell.makeFavorite.backgroundColor = [UIColor clearColor];
	cell.starsImageView.backgroundColor = [UIColor clearColor];
}


-(void) changeFavorite:(UIButton*)sender {
	if (self.appDelegate.loggedIn == YES) {
		NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
		[myNotificationCenter addObserver:self selector:@selector(confirmChange:) name:@"ProtocolListView" object:nil];
		NSString *thisProtocolId = [[self.menuItems objectAtIndex:sender.tag] objectForKey:@"ProtocolId"];
		self.favoriteProtocol = thisProtocolId;
		if ([sender.titleLabel.text isEqualToString:@"Make Favorite"]) {
			[self.appDelegate changeFavoriteProtocolId:thisProtocolId withChange:@"Add" forRequestingObject:@"ProtocolListView"];
		} else {
			[self.appDelegate changeFavoriteProtocolId:thisProtocolId withChange:@"Remove" forRequestingObject:@"ProtocolListView"];
		}
	} else {
		[GlobalMethods displayMessage:@"You must be logged in to change favorites"];
	}
}



-(void)confirmChange:(NSNotification*)notification {
	NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
	[myNotificationCenter removeObserver:self name:@"ProtocolListView" object:nil];
	//NSLog(@"[notification object] should be null %@",[notification object]);

	if (![notification object]) {
//		NSArray *tempArray1 = [[NSMutableArray alloc] initWithArray:[SQLiteAccess selectManyRowsWithSQL:@"SELECT ProtocolId FROM FavoriteProtocols"]];
//		
//		NSMutableArray *tempArray2 = [NSMutableArray array];
//		for (id item in tempArray1) {
//			[tempArray2 addObject:[item objectForKey:@"ProtocolId"]];
//		}
//		self.myFavorites = tempArray2;
//		[tempArray1 release];
//		self.appDelegate.favoritesChanged = NO;

		if (![self.myFavorites containsObject:self.favoriteProtocol]) {
			[self.myFavorites addObject:self.favoriteProtocol];
		} else {
			[self.myFavorites removeObject:self.favoriteProtocol];
		}
	}
	//NSLog(@"self.myFavorites %@",self.myFavorites);

	[GlobalMethods postNotification:@"StopFavoriteIndicator" withObject:nil];
	[self.tableViewOutlet reloadData];
}




#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
    
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        ProtocolWebViewController *protocolWebViewController = [[ProtocolWebViewController alloc] initWithNibName:@"ProtocolWebViewController" bundle:nil];
//        protocolWebViewController.navbarTitle = @"Protocol";
//        protocolWebViewController.title = nil;
//        protocolWebViewController.selectedProtocolId = [[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"ProtocolId"];
//        protocolWebViewController.view.frame = CGRectMake(448, 0, 448, 1004);
//        [self.view addSubview:protocolWebViewController.view];
//        
//        [UIView animateWithDuration:0.3 animations:^{
//            protocolWebViewController.view.frame = CGRectMake(0, 0, 448, 1004);
//        }];
//    }
//    else{
        ProtocolWebViewController *protocolWebViewController = [[ProtocolWebViewController alloc] initWithNibName:@"ProtocolWebViewController" bundle:nil];
        protocolWebViewController.protocolName = navbarTitle;
        protocolWebViewController.selectedProtocolId = [[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"ProtocolId"];
        [self.navigationController pushViewController:protocolWebViewController animated:YES];
        
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

