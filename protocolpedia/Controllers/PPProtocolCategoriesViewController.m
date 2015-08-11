//
//  PPProtocolCategoriesViewController.m
//  ProtocolPedia
//
//  20/02/14.


#import "PPProtocolCategoriesViewController.h"

#import "PPProtocolsListViewController.h"
#import "PPFavoriteProtocolsViewController.h"
#import "ProtocolCategoryViewCell.h"
#import "SQLiteAccess.h"

@interface PPProtocolCategoriesViewController ()

@end

@implementation PPProtocolCategoriesViewController

@synthesize tableView, dataSource;

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
    
    UIImage *slideLeftImage = [UIImage imageNamed:@"btn_slide_left.png"];
    [self setLeftBarButton:slideLeftImage];
    
    UIImage *slideRightImage = [UIImage imageNamed:@"heartRedNavButton.png"];
    [self setRightBarButton:slideRightImage];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    applicationDelegate.viewDeckController.panningMode = IIViewDeckFullViewPanning;
    
	self.dataSource = (NSMutableArray*)[SQLiteAccess selectManyRowsWithSQL:@"SELECT * FROM Categories WHERE CategoryType = \"Protocol\" AND CategoryId <> \"1\" ORDER BY Name"];
    
	[self.tableView reloadData];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //applicationDelegate.viewDeckController.panningMode = IIViewDeckNoPanning;
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

- (void)configureCell:(ProtocolCategoryViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    cell.protocolCategoryTitleLabel.text = [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"Name"];
    
    cell.protocolCategoryDescriptionLabel.text = [NSString stringWithFormat:@"%@ protocols",[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"NumberOfItems"]];
    
    UIImage *tempImage =  [UIImage imageNamed:[NSString stringWithFormat:@"Cat%@.jpg",[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"CategoryId"]]];
    
    if (tempImage) {
        cell.protocolCategoryImageView.image = tempImage;
    } else {
        tempImage =  [UIImage imageNamed:[NSString stringWithFormat:@"CatImage%@.png",[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"Name"]]];
        if (tempImage) {
            cell.imageView.image = tempImage;
        } else {
            cell.protocolCategoryImageView.image = [UIImage imageNamed:@"questionmark.png"];
        }
        
    }

}


- (NSString *)cellNibName{
    return @"ProtocolCategoryViewCell";
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    PPProtocolsListViewController *protocolsListVC = [[PPProtocolsListViewController alloc] initWithNibName:@"PPProtocolsListViewController" bundle:nil];
    protocolsListVC.categoryID = [[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"CategoryId"];
    protocolsListVC.isPushed = YES;
//    [self.navigationController pushViewController:protocolsListVC animated:YES];
    [delegate.navigationController pushViewController:protocolsListVC animated:YES];
    
}

- (IBAction)onRightBarButton:(id)sender {
    PPFavoriteProtocolsViewController *favoriteListVC = [[PPFavoriteProtocolsViewController alloc] initWithNibName:@"PPFavoriteProtocolsViewController" bundle:nil];
    favoriteListVC.isPushed = YES;
    [self.navigationController pushViewController:favoriteListVC animated:YES];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
