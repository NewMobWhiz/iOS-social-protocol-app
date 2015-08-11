//
//  PPMainViewController.m
//  ProtocolPedia
//
//   9/7/14.


#import "PPMainViewController.h"
#import "PPTabViewController.h"
#import "PPHomeViewController.h"
#import "PPProtocolsListViewController.h"
#import "PPProtocolCategoriesViewController.h"
#import "PPVideoCategorisViewController.h"
#import "PPCalculatorListViewController.h"
#import "PPDiscussionCategoriesViewController.h"
#import "PPDiscussionsViewController.h"
#import "PPNewHomeViewController.h"
@interface PPMainViewController () {
    IBOutlet UITabBar *mainTabBar;
}

@end

@implementation PPMainViewController

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
    mainTabBar.delegate = self;
    controllers = [[NSMutableArray alloc] init];
    [controllers addObject:[[PPNewHomeViewController alloc] init]];
    
//    UINavigationController* tab2Controller = [[UINavigationController alloc] initWithRootViewController:[[PPProtocolCategoriesViewController alloc] init]];
//    tab2Controller.navigationBarHidden = YES;
    [controllers addObject:[[PPProtocolCategoriesViewController alloc] init]];
    
    [controllers addObject:[[PPVideoCategorisViewController alloc] init]];
    [controllers addObject:[[PPCalculatorListViewController alloc] init]];
    [controllers addObject:[[PPDiscussionsViewController alloc] init]];
    
    [self tabBar:mainTabBar didSelectItem:[mainTabBar.items objectAtIndex:0]];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[controllers objectAtIndex:0] viewWillAppear:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    UIViewController *controller = [controllers objectAtIndex:item.tag];
    if (controller != nil) {
        for (UIView *view in tabViewContainner.subviews) {
            [view removeFromSuperview];
        }
        [tabViewContainner addSubview:controller.view];
    }
}
@end
