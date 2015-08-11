//
//  PPSearchResultsViewController.m
//  ProtocolPedia
//
//  25/06/14.


#import "PPSearchResultsViewController.h"

#import "SQLiteAccess.h"
#import "GlobalMethods.h"

#import "ProtocolsListViewCell.h"

#import "ProtocolWebViewController.h"
#import "ThreadWebViewController.h"
#import "VideoWebViewController.h"

@interface PPSearchResultsViewController ()

@end

@implementation PPSearchResultsViewController

@synthesize tableView, dataSource;
@synthesize protocolSearchResults, topicsSearchResults, videosSearchResults;
@synthesize myFavorites, favoriteProtocol;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImage *backImage = [UIImage imageNamed:@"btn_back.png"];
    [self setBackButton:backImage];
    
    applicationDelegate.searchResultfavoritesChanged = YES;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
    if (applicationDelegate.searchResultfavoritesChanged) {
		NSArray *tempArray1 = [[NSMutableArray alloc] initWithArray:[SQLiteAccess selectManyRowsWithSQL:@"SELECT ProtocolId FROM FavoriteProtocols"]];
		NSMutableArray *tempArray2 = [NSMutableArray array];
		for (id item in tempArray1) {
			[tempArray2 addObject:[item objectForKey:@"ProtocolId"]];
		}
		self.myFavorites = tempArray2;
		applicationDelegate.searchResultfavoritesChanged = NO;
	}
	
    [self.tableView reloadData];
    
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
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
- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        ///////////////////////
		static NSString *CellIdentifier = @"Cell1";
		
		ProtocolsListViewCell *cell = (ProtocolsListViewCell*)[tableView_ dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[ProtocolsListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
		
		cell.protocolLabel.text = [[self.protocolSearchResults objectAtIndex:indexPath.row] objectForKey:@"Title"];
		
        UIImage *tempImage = [UIImage imageNamed:[NSString stringWithFormat:@"%iStars.png",[[[self.protocolSearchResults objectAtIndex:indexPath.row] objectForKey:@"Stars"]intValue]]];
		if(tempImage) {
			cell.starsImageView.image = tempImage;
		} else {
			cell.starsImageView.image = [UIImage imageNamed:@"questionmark.png"];
		}
        
		[cell.favoriteButton addTarget:self action:@selector(changeFavorite:) forControlEvents:UIControlEventTouchUpInside];
		cell.favoriteButton.tag = indexPath.row;
		if ([self.myFavorites containsObject:[[self.protocolSearchResults objectAtIndex:indexPath.row] objectForKey:@"ProtocolId"]]) {
			[cell.favoriteButton setTitle:@"Remove Favorite" forState:UIControlStateNormal];
            [cell.favoriteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
			//cell.favorite = YES;
		} else {
			[cell.favoriteButton setTitle:@"Make Favorite" forState:UIControlStateNormal];
            [cell.favoriteButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
			//cell.favorite = NO;
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


-(void)tableView:(UITableView *)tableView willDisplayCell:(ProtocolsListViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		cell.protocolLabel.backgroundColor  = [UIColor clearColor];
        cell.favoriteButton.backgroundColor = [UIColor clearColor];
		cell.starsImageView.backgroundColor = [UIColor clearColor];
	}
}




#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView_ deselectRowAtIndexPath:indexPath animated:NO];
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
	if (applicationDelegate.loggedIn == YES) {
		NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
		[myNotificationCenter addObserver:self selector:@selector(confirmChange:) name:@"SearchResultListView" object:nil];
		NSString *thisProtocolId = [[self.protocolSearchResults objectAtIndex:sender.tag] objectForKey:@"ProtocolId"];
		self.favoriteProtocol = thisProtocolId;
		if ([sender.titleLabel.text isEqualToString:@"Make Favorite"]) {
			[applicationDelegate changeFavoriteProtocolId:thisProtocolId withChange:@"Add" forRequestingObject:@"SearchResultListView"];
		} else {
			[applicationDelegate changeFavoriteProtocolId:thisProtocolId withChange:@"Remove" forRequestingObject:@"SearchResultListView"];
		}
	} else {
		[GlobalMethods displayMessage:@"You must be logged in to change favorites"];
	}
}



-(void)confirmChange:(NSNotification*)notification {
	NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
	[myNotificationCenter removeObserver:self name:@"SearchResultListView" object:nil];
	
	if (![notification object]) {
		if (![self.myFavorites containsObject:self.favoriteProtocol]) {
			[self.myFavorites addObject:self.favoriteProtocol];
		} else {
			[self.myFavorites removeObject:self.favoriteProtocol];
		}
	}
	
	[GlobalMethods postNotification:@"StopFavoriteIndicator" withObject:nil];
	[self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
