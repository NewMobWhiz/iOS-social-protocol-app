//
//  AboutViewController.m
//  ProtocolPedia
//
//   7/16/10.


#import "AboutViewController.h"
#import "PPHomeViewController.h"
#import "PPLeftMenuViewController.h"

@implementation AboutViewController

@synthesize versionLabel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withRevealBlock:(RevealBlock)revealBlock{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    applicationDelegate.viewDeckController.panningMode = IIViewDeckFullViewPanning;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
//    UIImage *slideLeftImage = [UIImage imageNamed:@"btn_slide_left.png"];
//    [self setLeftBarButton:slideLeftImage];
    gobackBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_slide_left.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = gobackBarItem;
	
//    NSString *version =[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleVersion"];
//	versionLabel.text = [NSString stringWithFormat:@"Version %@", version];
	
}

-(void) goBack:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger backValue = [defaults integerForKey:@"BackInfo"];
    if (backValue == 1) {
        PPHomeViewController *homeVC = [[PPHomeViewController alloc] initWithNibName:@"PPHomeViewController" bundle:nil];
        [applicationDelegate.navigationController setViewControllers:[NSArray arrayWithObject:homeVC] animated:NO];
        [applicationDelegate.viewDeckController closeOpenViewAnimated:YES];
        [defaults setInteger:0 forKey:@"BackInfo"];
    } else {
        PPLeftMenuViewController *leftVC = [[PPLeftMenuViewController alloc] initWithNibName:@"PPLeftMenuViewController" bundle:nil];
        [applicationDelegate.navigationController setViewControllers:[NSArray arrayWithObject:leftVC] animated:NO];
        [applicationDelegate.viewDeckController closeOpenViewAnimated:YES];
    }
    
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.versionLabel = nil;
}

//- (void)onLeftBarButton:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
//}



@end
