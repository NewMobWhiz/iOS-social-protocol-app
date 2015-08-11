//
//  PPNewHomeViewController.m
//  ProtocolPedia
//
//   9/8/14.


#import "PPNewHomeViewController.h"
#import "PPHomeViewController.h"
#import "PPSearchProtocolsViewController.h"
#import "AboutViewController.h"
#import "PPAppDelegate.h"
#import "PPFavoriteProtocolsViewController.h"
//#import "PP"
@interface PPNewHomeViewController () {
    PPAppDelegate *appDeleagate;
}

@end

@implementation PPNewHomeViewController

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
    appDeleagate = [UIApplication sharedApplication].delegate;
    tableData.dataSource = self;
    tableData.delegate = self;
    tableData.backgroundColor = [UIColor clearColor];
    [tableData reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [tableData reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if(cell == nil) {
        if (indexPath.section == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CELL"];
        } else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
        }
    }

    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Login to ProtocolPedia";
                if (appDeleagate.loggedIn) {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"Logged in as %@", appDeleagate.username];
                } else {
                    cell.detailTextLabel.text = @"Not logged in";
                }
                break;
            case 1:
                cell.textLabel.text = @"New to Protocolpedia ?";
                cell.detailTextLabel.text = @"Click here to register";
                break;
            default:
                break;
        }
    } else {

        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"View Favourite Protocols";
                cell.imageView.image = [UIImage imageNamed:@"favorites.png"];
                break;
            case 1:
                cell.textLabel.text = @"Search Protocols";
                cell.imageView.image = [UIImage imageNamed:@"pp_notify.png"];
                break;
            case 2:
                cell.textLabel.text = @"About ProtocolPedia";
                cell.imageView.image = [UIImage imageNamed:@"about.png"];
                break;
            default:
                break;
        }
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIViewController *controller = nil;
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                PPHomeViewController *controller1 = [[PPHomeViewController alloc] init];
                controller1.tabIndex = 0;
                controller = controller1;
            }
                break;
            case 1:
            {
                PPHomeViewController *controller2 = [[PPHomeViewController alloc] init];
                controller2.tabIndex = 1;
                controller = controller2;
            }
                break;
            default:
                break;
        }
    } else {
        
        switch (indexPath.row) {
            case 0:
                controller = [[PPFavoriteProtocolsViewController alloc] init];
                break;
            case 1:
                controller = [[PPSearchProtocolsViewController alloc] init];
                break;
            case 2:
                controller = [[AboutViewController alloc] init];
                break;
            default:
                break;
        }
        
    }
    PPAppDelegate *delegate = (PPAppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *nav = (UINavigationController *)delegate.window.rootViewController;
    nav.navigationBarHidden  = NO;
    [nav pushViewController:controller animated:YES];
}
@end
