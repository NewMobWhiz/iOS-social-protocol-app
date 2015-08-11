//
//  PPProtocolsListViewController.m
//  ProtocolPedia
//
//  21/02/14.


#import "PPProtocolsListViewController.h"
#import "ProtocolsListViewCell.h"
#import "ProtocolWebViewController.h"
#import "SQLiteAccess.h"

@interface PPProtocolsListViewController (){
    NSString *favoriteProtocol;
}

@end

@implementation PPProtocolsListViewController

@synthesize tableView, dataSource;
@synthesize categoryID;
@synthesize isPushed;
@synthesize myFavorites;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSString *)sqlRequestString{
    return [NSString stringWithFormat:@"SELECT Protocols.ProtocolId, Protocols.Title, Protocols.NumberOfReviews, Protocols.Stars FROM Protocols LEFT JOIN CategoryRelations ON Protocols.ProtocolId = CategoryRelations.ProtocolId WHERE CategoryRelations.CategoryId = \"%@\" ORDER BY \"CategoryRelations.CategoryOrdering\"",self.categoryID];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.isPushed) {
        UIImage *backImage = [UIImage imageNamed:@"btn_back.png"];
        [self setBackButton:backImage];
    }
    else {
        UIImage *slideLeftImage = [UIImage imageNamed:@"btn_slide_left.png"];
        [self setLeftBarButton:slideLeftImage];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (applicationDelegate.protocolListfavoritesChanged) {
		
		NSArray *tempArray1 = [[NSMutableArray alloc] initWithArray:[SQLiteAccess selectManyRowsWithSQL:@"SELECT ProtocolId FROM FavoriteProtocols"]];
        
		NSMutableArray *tempArray2 = [NSMutableArray array];
		for (id item in tempArray1) {
			[tempArray2 addObject:[item objectForKey:@"ProtocolId"]];
		}
		self.myFavorites = tempArray2;
		applicationDelegate.protocolListfavoritesChanged = NO;
		
	}
    
    if (self.isPushed)
        applicationDelegate.viewDeckController.panningMode = IIViewDeckNoPanning;
    else
        applicationDelegate.viewDeckController.panningMode = IIViewDeckFullViewPanning;
    
    self.dataSource = (NSMutableArray *)[SQLiteAccess selectManyRowsWithSQL:[self sqlRequestString]];
    
	[self.tableView reloadData];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    
    self.tableView = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.dataSource count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if ([self cellNibName] != nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:[self cellNibName] owner:nil options:nil];
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                    cell = currentObject;
                    break;
                }
            }
        } else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        [self configureCell:cell atIndexPath:indexPath];
        return cell;
    }
}

- (void)configureCell:(ProtocolsListViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.protocolLabel.text = [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"Title"];
    
	UIImage *tempImage = [UIImage imageNamed:[NSString stringWithFormat:@"%iStars.png",[[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"Stars"]intValue]]];
	if(tempImage) {
		cell.starsImageView.image = tempImage;
	} else {
		cell.starsImageView.image = [UIImage imageNamed:@"questionmark.png"];
	}
    
	cell.favoriteButton.tag = indexPath.row;
	
    [cell.favoriteButton addTarget:self action:@selector(changeFavorite:) forControlEvents:UIControlEventTouchUpInside];
	cell.favoriteButton.tag = indexPath.row;
	if ([self.myFavorites containsObject:[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"ProtocolId"]]) {
		[cell.favoriteButton setTitle:@"Remove Favorite" forState:UIControlStateNormal];
		[cell.favoriteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
		//cell.favorite = YES;
	} else {
		[cell.favoriteButton setTitle:@"Make Favorite" forState:UIControlStateNormal];
		[cell.favoriteButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
		//cell.favorite = NO;
	}
    
}

-(void) changeFavorite:(UIButton*)sender {
	if (applicationDelegate.loggedIn == YES) {
		NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
		[myNotificationCenter addObserver:self selector:@selector(confirmChange:) name:@"ProtocolListView" object:nil];
		NSString *thisProtocolId = [[self.dataSource objectAtIndex:sender.tag] objectForKey:@"ProtocolId"];
		favoriteProtocol = thisProtocolId;
		if ([sender.titleLabel.text isEqualToString:@"Make Favorite"]) {
			[applicationDelegate changeFavoriteProtocolId:thisProtocolId withChange:@"Add" forRequestingObject:@"ProtocolListView"];
		} else {
			[applicationDelegate changeFavoriteProtocolId:thisProtocolId withChange:@"Remove" forRequestingObject:@"ProtocolListView"];
		}
	} else {
		[GlobalMethods displayMessage:@"You must be logged in to change favorites"];
	}
}



-(void)confirmChange:(NSNotification*)notification {
	NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
	[myNotificationCenter removeObserver:self name:@"ProtocolListView" object:nil];
	
	if (![notification object]) {
        
		if (![self.myFavorites containsObject:favoriteProtocol]) {
			[self.myFavorites addObject:favoriteProtocol];
		} else {
			[self.myFavorites removeObject:favoriteProtocol];
		}
	}
	
	[GlobalMethods postNotification:@"StopFavoriteIndicator" withObject:nil];
	[self.tableView reloadData];
}

///////
- (IBAction)favoriteButtonPressed:(id)sender{
   
}

- (NSString *)cellNibName{
    return @"ProtocolsListViewCell";
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	ProtocolWebViewController *protocolWebViewController = [[ProtocolWebViewController alloc] initWithNibName:@"ProtocolWebViewController" bundle:nil];
    protocolWebViewController.selectedProtocolId = [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"ProtocolId"];
    [self.navigationController pushViewController:protocolWebViewController animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
