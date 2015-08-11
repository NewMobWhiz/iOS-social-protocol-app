//
//  PPSplashScreenViewController.m
//  ProtocolPedia
//
//  20/02/14.


#import "PPSplashScreenViewController.h"

#import "PPLeftMenuViewController.h"
#import "PPHomeViewController.h"
#import "PPProtocolCategoriesViewController.h"
#import "PPWebServices.h"

@interface PPSplashScreenViewController ()

@end

@implementation PPSplashScreenViewController

@synthesize backgroundImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) onLoginSucceed
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    PPProtocolCategoriesViewController *protocolCategoriesVC = [[PPProtocolCategoriesViewController alloc] initWithNibName:@"PPProtocolCategoriesViewController" bundle:nil];
    [applicationDelegate.navigationController setViewControllers:[NSArray arrayWithObject:protocolCategoriesVC] animated:NO];
    
}

-(void) onLoginFailed
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoginSucceed) name:PP_NOTIFICATION_AUTHENTIFICATION_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoginFailed) name:PP_NOTIFICATION_AUTHENTIFICATION_FAILED object:nil];
    
    if(applicationDelegate.window.bounds.size.height == 568) {
        [self.backgroundImageView setImage: [UIImage imageNamed: @"Default-568h@2x.png"]];
    } else {
        [self.backgroundImageView setImage: [UIImage imageNamed: @"Default.png"]];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    PPLeftMenuViewController * leftVC = [[PPLeftMenuViewController alloc] initWithNibName:@"PPLeftMenuViewController" bundle:nil];
    
    PPHomeViewController *homeVC = [[PPHomeViewController alloc] initWithNibName:@"PPHomeViewController" bundle:nil];
    
    NSUserDefaults *standardsUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardsUserDefaults) {
        if ([standardsUserDefaults objectForKey:kPPUsername] && [standardsUserDefaults objectForKey:kPPPassword]) {
            [[PPWebServices sharedInstance] connectWithLogin:[standardsUserDefaults objectForKey:kPPUsername] andPasswd:[standardsUserDefaults objectForKey:kPPPassword]];
        }
        else
            [applicationDelegate.navigationController setViewControllers:@[homeVC]];
    }
    
    
    
    [applicationDelegate.viewDeckController setLeftController: leftVC];
    
    applicationDelegate.viewDeckController.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
    applicationDelegate.viewDeckController.panningCancelsTouchesInView = YES;
    
    if(!applicationDelegate.isAtLeast7) {
        CGRect frame = applicationDelegate.viewDeckController.view.frame;
        frame.origin.y = 20;
        frame.size.height = applicationDelegate.window.frame.size.height - 20;
        applicationDelegate.viewDeckController.view.frame = frame;
    }
    
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


- (void)viewDidUnload{
    [super viewDidUnload];
    
    self.backgroundImageView = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) SignInSuccess: (int)userID
{
    
    PPProtocolCategoriesViewController *protocolCategoriesVC = [[PPProtocolCategoriesViewController alloc] initWithNibName:@"PPProtocolCategoriesViewController" bundle:nil];
    
    [applicationDelegate.navigationController setViewControllers:[NSArray arrayWithObject:protocolCategoriesVC] animated:NO];
    applicationDelegate.viewDeckController.panningMode = IIViewDeckFullViewPanning;
    [applicationDelegate.viewDeckController closeOpenViewAnimated:YES];
}

-(void) SignInFailed
{
    NSLog(@"Signin failed");
    UIAlertView *alert = [[UIAlertView alloc ] initWithTitle:@"ProtocolPedia" message:@"The username or password you entered is incorrect." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

@end
