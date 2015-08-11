//
//  FavoriteListViewController.m
//  ProtocolPedia
//
//   8/17/10.


#import "FavoriteListViewController.h"
#import "ProtocolCell.h"
#import "SQLiteAccess.h"
#import "ProtocolWebViewController.h"

@implementation FavoriteListViewController

@synthesize thisFavorite;
@synthesize currentTag, viewHeader;

#pragma mark -
#pragma mark View lifecycle

- (void)revealSidebar {
    if ([_typeView intValue] == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
	else{
        _revealBlock();
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withRevealBlock:(RevealBlock)revealBlock{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _revealBlock = [revealBlock copy];
        
        self.navigationController.navigationBarHidden = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.currentTag = 0;
//	NSString *selectProtocols = @"SELECT ProtocolId, Title, NumberOfReviews, Stars FROM Protocols WHERE ProtocolId IN (SELECT ProtocolId FROM FavoriteProtocols)";
//	NSMutableArray *tempMenuItems =  (NSMutableArray*)[[NSMutableArray alloc] initWithArray:[SQLiteAccess selectManyRowsWithSQL:selectProtocols]];
//	self.menuItems = tempMenuItems;
//	[tempMenuItems release];
	self.appDelegate.favoritesChanged = YES;


}

- (void)viewWillAppear:(BOOL)animated {
//NSLog(@"viewWillAppear");
	if (self.appDelegate.favoritesChanged) {
		NSString *selectProtocols = @"SELECT ProtocolId, Title, NumberOfReviews, Stars FROM Protocols WHERE ProtocolId IN (SELECT ProtocolId FROM FavoriteProtocols)";
		NSMutableArray *tempMenuItems =  (NSMutableArray*)[[NSMutableArray alloc] initWithArray:[SQLiteAccess selectManyRowsWithSQL:selectProtocols]];
		self.menuItems = tempMenuItems;
		self.appDelegate.favoritesChanged = NO;
	}
	[self.tableViewOutlet reloadData];
    
    if (viewHeader) {
        [viewHeader removeFromSuperview];
        viewHeader = nil;
    }
    if ([_typeView intValue] != 2) {
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
        lb1.text = @"Favorite Protocols";
        lb1.textAlignment = UITextAlignmentCenter;
        [viewHeader addSubview:lb1];
        
        UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 46, 40)] ;
        [btnBack setImage:[UIImage imageNamed:@"icn_menu_main.png"] forState:UIControlStateNormal];
        [btnBack addTarget:self action:@selector(revealSidebar) forControlEvents:UIControlEventTouchUpInside];
        [viewHeader addSubview:btnBack];
    }
    
    
    UIColor *myColor = [UIColor colorWithRed:([[self.appDelegate.settings objectForKey:@"Red"] floatValue]/255.0) green:([[self.appDelegate.settings objectForKey:@"Green"] floatValue]/255.0) blue:([[self.appDelegate.settings objectForKey:@"Blue"] floatValue]/255.0) alpha:1.0];
    UIColor *myTintColor = [UIColor colorWithRed:([[self.appDelegate.settings objectForKey:@"TintRed"] floatValue]/255.0) green:([[self.appDelegate.settings objectForKey:@"TintGreen"] floatValue]/255.0) blue:([[self.appDelegate.settings objectForKey:@"TintBlue"] floatValue]/255.0) alpha:1.0];
    self.navigationController.navigationBar.tintColor = myTintColor;
    self.view.backgroundColor = myColor;
    viewHeader.backgroundColor = myTintColor;
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
        cell = [[ProtocolCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
	
    cell.protocolName.text = [[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"Title"];
	//   cell.reviews.text = [[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"NumberOfReviews"];
	UIImage *tempImage = [UIImage imageNamed:[NSString stringWithFormat:@"%iStars.png",[[[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"Stars"]intValue]]];
	if(tempImage) {
		cell.starsImageView.image = tempImage;
	} else {
		cell.starsImageView.image = [UIImage imageNamed:@"questionmark.png"];
	}
//	cell.makeFavorite.titleLabel.text = [[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"ProtocolId"];
	[cell.makeFavorite addTarget:self action:@selector(changeFavorite:) forControlEvents:UIControlEventTouchUpInside];
	cell.makeFavorite.tag = indexPath.row;
	[cell.makeFavorite setTitle:@"Remove Favorite" forState:UIControlStateNormal];
    [cell.makeFavorite setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
	cell.favorite = YES;

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
		[myNotificationCenter addObserver:self selector:@selector(confirmChange:) name:@"FavoriteListView" object:nil];
		self.currentTag = sender.tag;
		self.thisFavorite = [[self.menuItems objectAtIndex:sender.tag] objectForKey:@"ProtocolId"];
		[self.appDelegate changeFavoriteProtocolId:self.thisFavorite withChange:@"Remove" forRequestingObject:@"FavoriteListView"];
	} else {
		[GlobalMethods displayMessage:@"You must be logged in to change favorites"];
	}
}


-(void)confirmChange:(NSNotification*)notification {
	NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
	[myNotificationCenter removeObserver:self name:@"FavoriteListView" object:nil];
//NSLog(@"[notification object]%@",[notification object]);
	//NSLog(@"self.menuItems before  %@",self.menuItems );
	if (![notification object]) {
		[self.menuItems removeObjectAtIndex:self.currentTag];
	//	NSLog(@"removeObject");


	}
	//NSLog(@"self.menuItems after %@",self.menuItems );
	[GlobalMethods postNotification:@"StopFavoriteIndicator" withObject:nil];
	[self.tableViewOutlet reloadData];
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
        ProtocolWebViewController *protocolWebViewController = [[ProtocolWebViewController alloc] initWithNibName:@"ProtocolWebViewController" bundle:nil];
        protocolWebViewController.selectedProtocolId = [[self.menuItems objectAtIndex:indexPath.row] objectForKey:@"ProtocolId"];
        [self.navigationController pushViewController:protocolWebViewController animated:YES];
    
}

-(void)closeSubView{
    if ([self.view viewWithTag:999]) {
        UIView *v = [self.view viewWithTag:999];
        [v removeFromSuperview];
        v = nil;
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

