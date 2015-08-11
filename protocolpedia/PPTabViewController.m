//
//  PPTabViewController.m
//  ProtocolPedia
//
//   9/7/14.


#import "PPTabViewController.h"
#import "PPHomeViewController.h"
#import "PPProtocolsListViewController.h"
#import "PPProtocolCategoriesViewController.h"
#import "PPVideoCategorisViewController.h"
#import "PPCalculatorListViewController.h"
#import "PPDiscussionCategoriesViewController.h"
#import "PPDiscussionsViewController.h"
@interface PPTabViewController ()

@end

@implementation PPTabViewController

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
    // Do any additional setup after loading the view.
    UIViewController *homeController = [[PPHomeViewController alloc] init];
    homeController.title = @"Home";
    UIViewController *protocolController = [[PPProtocolCategoriesViewController alloc] init];
    protocolController.title = @"Protocols";
    UIViewController *videoController = [[PPVideoCategorisViewController alloc] init];
    videoController.title = @"Videos";
    UIViewController *calculatorController = [[PPCalculatorListViewController alloc] init];
    calculatorController.title = @"Calculators";
    UIViewController *forumController = [[PPDiscussionsViewController alloc] init];
    forumController.title = @"Forum";
    self.viewControllers = [NSArray arrayWithObjects: homeController, protocolController, videoController, calculatorController, forumController, nil];
    self.tabBar.frame = CGRectMake(0, 0, 320, self.tabBar.frame.size.height);
    self.view.frame = CGRectMake(0, self.tabBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    
    
//    NSArray* controllers = [NSArray arrayWithObjects:[[ProfileViewController alloc] init],[[ContactsViewController alloc] init],[[SendViewController alloc] init],[[ViewController alloc] init],[[SettingViewController alloc] init], nil];
//    NSArray* tabItemImages = [NSArray arrayWithObjects:@"icon_avatar_docs.png", @"icon_doc.png", @"icon_lion_setting.png", @"icon_chat_comment.png", @"icon_config.png", nil];
//    NSArray* tabItemImagesSelected = [NSArray arrayWithObjects:@"icon_avatar_docs_selected.png", @"icon_doc_selected.png", @"icon_lion_setting_selected.png", @"icon_chat_comment_selected.png", @"icon_config_selected.png", nil];
//    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"bg_bottom_bar.png"]];
//    for (int i = 0; i < controllers.count; i++) {
//        UIViewController* controllerChild = [controllers objectAtIndex:i];
//        UINavigationController* controller = [[UINavigationController alloc] initWithRootViewController:controllerChild];
//        [self addChildViewController:controller];
//        controller.navigationBarHidden = YES;
//        [controller.tabBarItem setImage:[UIImage imageNamed:[tabItemImages objectAtIndex:i]]];
//        [controller.tabBarItem setSelectedImage:[UIImage imageNamed:[tabItemImagesSelected objectAtIndex:i]]];
//        [controller.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:[tabItemImagesSelected objectAtIndex:i]] withFinishedUnselectedImage:[UIImage imageNamed:[tabItemImages objectAtIndex:i]]];
//        controller.tabBarItem.imageInsets =  UIEdgeInsetsMake(6, 0, -6, 0);
//        controller.tabBarItem.title = nil;
//    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
