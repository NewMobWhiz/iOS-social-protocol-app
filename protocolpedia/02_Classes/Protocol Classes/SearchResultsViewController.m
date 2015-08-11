//
//  SearchResultsViewController.m
//  ProtocolPedia
//
//   8/17/10.


#import "SearchResultsViewController.h"
#import "ProtocolWebViewController.h"
#import "AddThreadViewController.h"
#import "VideoWebViewController.h"
#import "SQLiteAccess.h"
#import "ProtocolCell.h"
#import "ThreadWebViewController.h"


@implementation SearchResultsViewController

@synthesize protocolSearchResults;
@synthesize topicsSearchResults;
@synthesize videosSearchResults;
@synthesize myFavorites;
@synthesize favoriteProtocol;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    float wDevice = 320;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        wDevice = 768;
    }
    else{
        wDevice = 320;
    }
    
    
	self.appDelegate.searchResultfavoritesChanged = YES;
    viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wDevice, 50)];
    viewHeader.backgroundColor = [UIColor colorWithRed:46.0/255 green:133.0/255 blue:189.0/255 alpha:1.0];
    [self.view addSubview:viewHeader];
    
    UILabel *lb1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, wDevice, 50)];
    lb1.textColor = [UIColor whiteColor];
    lb1.backgroundColor = [UIColor clearColor];
    lb1.font = [UIFont fontWithName:@"Arial" size:18];
    lb1.text = @"Search Results";
    lb1.textAlignment = UITextAlignmentCenter;
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
	if (self.appDelegate.searchResultfavoritesChanged) {
		NSArray *tempArray1 = [[NSMutableArray alloc] initWithArray:[SQLiteAccess selectManyRowsWithSQL:@"SELECT ProtocolId FROM FavoriteProtocols"]];
		NSMutableArray *tempArray2 = [NSMutableArray array];
		for (id item in tempArray1) {
			[tempArray2 addObject:[item objectForKey:@"ProtocolId"]];
		}
		self.myFavorites = tempArray2;
		self.appDelegate.searchResultfavoritesChanged = NO;
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
//	int sections = 0;
//	if ([self.protocolSearchResults > 0]) {
//		sections++;
//	}
//	if ([self.topicsSearchResults > 0]) {
//		sections++;
//	}
//	if ([self.videosSearchResults > 0]) {
//		sections++;
//	}
//    return sections;

	return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return @"Protocols";
	} else if (section == 1) {
		return @"Forum Topics";
	} else if (section == 2) {
		return @"Video Links";
	}
    return nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (section == 0) {
		return [self.protocolSearchResults count];
	} else if (section == 1) {
		return [self.topicsSearchResults count];
	} else if (section == 2) {
		return [self.videosSearchResults count];
	}
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		return 70;
	} 
	return 44;
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {

		 ///////////////////////
		static NSString *CellIdentifier = @"Cell1";
		
		ProtocolCell *cell = (ProtocolCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[ProtocolCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
		
		cell.protocolName.text = [[self.protocolSearchResults objectAtIndex:indexPath.row] objectForKey:@"Title"];
		//   cell.reviews.text = [[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"NumberOfReviews"];
		UIImage *tempImage = [UIImage imageNamed:[NSString stringWithFormat:@"%iStars.png",[[[self.protocolSearchResults objectAtIndex:indexPath.row] objectForKey:@"Stars"]intValue]]];
		if(tempImage) {
			cell.starsImageView.image = tempImage;
		} else {
			cell.starsImageView.image = [UIImage imageNamed:@"questionmark.png"];
		}

		[cell.makeFavorite addTarget:self action:@selector(changeFavorite:) forControlEvents:UIControlEventTouchUpInside];
		cell.makeFavorite.tag = indexPath.row;
		if ([self.myFavorites containsObject:[[self.protocolSearchResults objectAtIndex:indexPath.row] objectForKey:@"ProtocolId"]]) {
			[cell.makeFavorite setTitle:@"Remove Favorite" forState:UIControlStateNormal];
            [cell.makeFavorite setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
			cell.favorite = YES;
		} else {
			[cell.makeFavorite setTitle:@"Make Favorite" forState:UIControlStateNormal];
            [cell.makeFavorite setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
			cell.favorite = NO;
		}
		return cell;
	////////////////////	 
		 
	} else {
		static NSString *CellIdentifier2 = @"Cell2";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		if (indexPath.section == 1) {
			cell.textLabel.text = [[self.topicsSearchResults objectAtIndex:indexPath.row] objectForKey:@"Subject"];
		} else if (indexPath.section == 2) {
			cell.textLabel.text = [[self.videosSearchResults objectAtIndex:indexPath.row] objectForKey:@"Title"];
		}
		 return cell;
    }
    return nil;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(ProtocolCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath { 
	if (indexPath.section == 0) {
		cell.protocolName.backgroundColor  = [UIColor clearColor];
//		cell.reviews.backgroundColor  = [UIColor clearColor];
//		cell.reviewsLabel.backgroundColor  = [UIColor clearColor];
		cell.makeFavorite.backgroundColor = [UIColor clearColor];
		cell.starsImageView.backgroundColor = [UIColor clearColor];
	}
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
    if (indexPath.section == 0) {
		ProtocolWebViewController *protocolWebViewController = [[ProtocolWebViewController alloc] initWithNibName:@"ProtocolWebViewController" bundle:nil];
		protocolWebViewController.selectedProtocolId = [[self.protocolSearchResults objectAtIndex:indexPath.row] objectForKey:@"ProtocolId"];
		[[self navigationController] pushViewController:protocolWebViewController animated:YES];
		
	} else if (indexPath.section == 1) {
		ThreadWebViewController *threadWebViewController = [[ThreadWebViewController alloc] initWithNibName:@"ThreadWebViewController" bundle:nil];
		threadWebViewController.threadTitle = [[self.topicsSearchResults objectAtIndex:indexPath.row] objectForKey:@"Subject"];
		threadWebViewController.threadId = [[self.topicsSearchResults objectAtIndex:indexPath.row] objectForKey:@"ThreadId"];
		[[self navigationController] pushViewController:threadWebViewController animated:YES];
		
	} else if (indexPath.section == 2) {
		if ([GlobalMethods canConnect]) {
			VideoWebViewController *videoWebViewController = [[VideoWebViewController alloc] initWithNibName:@"VideoWebViewController" bundle:nil];
			videoWebViewController.selectedVideoId = [[self.videosSearchResults objectAtIndex:indexPath.row] objectForKey:@"VideoId"];
			[[self navigationController] pushViewController:videoWebViewController animated:YES];
		
		} else {
			[GlobalMethods displayMessage:@"You must be connected to the internet to view video"];
		}
		
	}
}


-(void) changeFavorite:(UIButton*)sender {
	if (self.appDelegate.loggedIn == YES) {
		NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
		[myNotificationCenter addObserver:self selector:@selector(confirmChange:) name:@"SearchResultListView" object:nil];
		NSString *thisProtocolId = [[self.protocolSearchResults objectAtIndex:sender.tag] objectForKey:@"ProtocolId"];
		self.favoriteProtocol = thisProtocolId;
		if ([sender.titleLabel.text isEqualToString:@"Make Favorite"]) {
			[self.appDelegate changeFavoriteProtocolId:thisProtocolId withChange:@"Add" forRequestingObject:@"SearchResultListView"];
		} else {
			[self.appDelegate changeFavoriteProtocolId:thisProtocolId withChange:@"Remove" forRequestingObject:@"SearchResultListView"];
		}
	} else {
		[GlobalMethods displayMessage:@"You must be logged in to change favorites"];
	}
}



-(void)confirmChange:(NSNotification*)notification {
	NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
	[myNotificationCenter removeObserver:self name:@"SearchResultListView" object:nil];
	//NSLog(@"[notification object] should be null %@",[notification object]);
	
	if (![notification object]) {
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

