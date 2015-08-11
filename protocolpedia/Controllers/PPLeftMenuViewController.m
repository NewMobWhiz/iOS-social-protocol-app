//
//  PPLeftMenuViewController.m
//  ProtocolPedia
//
//  20/02/14.


#import "PPLeftMenuViewController.h"

#import "PPHomeViewController.h"
#import "PPProtocolCategoriesViewController.h"
#import "PPSearchProtocolsViewController.h"
#import "PPFavoriteProtocolsViewController.h"
#import "PPCalculatorListViewController.h"
#import "PPVideoCategorisViewController.h"
#import "PPDiscussionsViewController.h"
#import "ColorTestViewController.h"
#import "AboutViewController.h"
#import "LeftMenuViewCell.h"

@interface PPLeftMenuViewController ()

@end

@implementation PPLeftMenuViewController

@synthesize tableView;
@synthesize dataSource;

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
    
    self.dataSource =
    @[@{kSidebarCellImageKey: [UIImage imageNamed:@"icn_menu_1.png"], kSidebarCellTextKey:@"Protocols"}, @{kSidebarCellImageKey: [UIImage imageNamed:@"icn_menu_2.png"], kSidebarCellTextKey:@"Search"}, @{kSidebarCellImageKey: [UIImage imageNamed:@"icn_menu_3.png"], kSidebarCellTextKey:@"Favorite"}, @{kSidebarCellImageKey: [UIImage imageNamed:@"icn_menu_4.png"], kSidebarCellTextKey:@"Calculator"}, @{kSidebarCellImageKey: [UIImage imageNamed:@"icn_menu_5.png"], kSidebarCellTextKey:@"Videos"}, @{kSidebarCellImageKey: [UIImage imageNamed:@"icn_menu_6.png"], kSidebarCellTextKey:@"Discussions"}, @{kSidebarCellImageKey: [UIImage imageNamed:@"icn_menu_8.png"], kSidebarCellTextKey:@"Help"}, @{kSidebarCellImageKey: [UIImage imageNamed:@"icn_menu_9.png"], kSidebarCellTextKey:@"Log out"}];///, @{kSidebarCellImageKey: [UIImage imageNamed:@"FaceboolSelected.png"], kSidebarCellTextKey:@"FaceBook"}
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    [self.tableView reloadData];
    
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    
    self.tableView = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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


- (void)configureCell:(LeftMenuViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *info = self.dataSource[indexPath.row];
    
    cell.leftMenuTitle.text = info[kSidebarCellTextKey];
    cell.leftMenuImageView.image = info[kSidebarCellImageKey];
    
    
}


- (NSString *)cellNibName{
    return @"LeftMenuViewCell";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        PPProtocolCategoriesViewController *protocolCategoriesVC = [[PPProtocolCategoriesViewController alloc] initWithNibName:@"PPProtocolCategoriesViewController" bundle:nil];
        [applicationDelegate.navigationController setViewControllers:[NSArray arrayWithObject:protocolCategoriesVC] animated:NO];
        [applicationDelegate.viewDeckController closeOpenViewAnimated:YES];
    }
    
    if (indexPath.row == 1) {
        PPSearchProtocolsViewController *searchProtocolsVC = [[PPSearchProtocolsViewController alloc] initWithNibName:@"PPSearchProtocolsViewController" bundle:nil];
        [applicationDelegate.navigationController setViewControllers:[NSArray arrayWithObject:searchProtocolsVC] animated:NO];
        [applicationDelegate.viewDeckController closeOpenViewAnimated:YES];
    }
    
    if (indexPath.row == 2) {
        PPFavoriteProtocolsViewController *favoriteListVC = [[PPFavoriteProtocolsViewController alloc] initWithNibName:@"PPFavoriteProtocolsViewController" bundle:nil];
        [applicationDelegate.navigationController setViewControllers:[NSArray arrayWithObject:favoriteListVC] animated:NO];
        [applicationDelegate.viewDeckController closeOpenViewAnimated:YES];
    }
    
    if (indexPath.row == 3) {
        PPCalculatorListViewController *calculatorListVC = [[PPCalculatorListViewController alloc] initWithNibName:@"PPCalculatorListViewController" bundle:nil];
        [applicationDelegate.navigationController setViewControllers:[NSArray arrayWithObject:calculatorListVC] animated:NO];
        [applicationDelegate.viewDeckController closeOpenViewAnimated:YES];

    }
    
    if (indexPath.row == 4) {
        PPVideoCategorisViewController *videoCategoriesVC = [[PPVideoCategorisViewController alloc] initWithNibName:@"PPVideoCategorisViewController" bundle:nil];
        [applicationDelegate.navigationController setViewControllers:[NSArray arrayWithObject:videoCategoriesVC] animated:NO];
        [applicationDelegate.viewDeckController closeOpenViewAnimated:YES];
        
    }
    
    if (indexPath.row == 5) {
        PPDiscussionsViewController *forumRootVC = [[PPDiscussionsViewController alloc] initWithNibName:@"PPDiscussionsViewController" bundle:nil];
        [applicationDelegate.navigationController setViewControllers:[NSArray arrayWithObject:forumRootVC] animated:NO];
        [applicationDelegate.viewDeckController closeOpenViewAnimated:YES];
        
    }
    
    if (indexPath.row == 6) {
        AboutViewController *aboutVC = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
        [applicationDelegate.navigationController setViewControllers:[NSArray arrayWithObject:aboutVC] animated:NO];
        [applicationDelegate.viewDeckController closeOpenViewAnimated:YES];
        
    }
    
    if (indexPath.row == [self.dataSource count] - 1) {
        
        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        if (standardUserDefaults) {
            [standardUserDefaults setObject:nil forKey:kPPUsername];
            [standardUserDefaults setObject:nil forKey:kPPPassword];
            [standardUserDefaults synchronize];
        }
        
        PPHomeViewController *homeVC = [[PPHomeViewController alloc] initWithNibName:@"PPHomeViewController" bundle:nil];
        [applicationDelegate.navigationController setViewControllers:[NSArray arrayWithObject:homeVC] animated:NO];
        [applicationDelegate.viewDeckController closeOpenViewAnimated:YES];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
