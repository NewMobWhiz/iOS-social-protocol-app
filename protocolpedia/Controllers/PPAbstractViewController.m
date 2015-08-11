//
//  PPAbstractViewController.m
//  ProtocolPedia
//
//  06/04/14.


#import "PPAbstractViewController.h"

@interface PPAbstractViewController ()

@end

@implementation PPAbstractViewController

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
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    
//    UIImage *logoImage = [UIImage imageNamed:@"logo.png"];
//    [self setTitleImage:logoImage];
    delegate = (PPAppDelegate *)[UIApplication sharedApplication].delegate;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)setTitleView:(UIView *)titleView {
    [self.navigationItem setTitleView:titleView];
}

- (void)setTitleImage:(UIImage *)titleImage {
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:titleImage];
	[self setTitleView:titleImageView];
    
}

- (void)setBackButtonTitle:(NSString *)title {
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backBarButtonItem;
}

- (void)setBackButton:(UIImage *)normalImage{
    if(normalImage)
    {
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, normalImage.size.width, normalImage.size.height)];
        [backButton setBackgroundImage:normalImage forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(onBackButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        [self.navigationItem setHidesBackButton:YES animated:NO];
        self.navigationItem.leftBarButtonItem = backBarButtonItem;
        
       
    }
    else
    {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void)setLeftBarButton:(UIImage *)normalImage {
    if(normalImage)
    {
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, normalImage.size.width, normalImage.size.height)];
        [leftButton setBackgroundImage:normalImage forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(onLeftBarButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
       
    }
    else
    {
        self.navigationItem.leftBarButtonItem = nil;
    }
}


- (void)setRightBarButton:(UIImage *)normalImage {
    if(normalImage)
    {
        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, normalImage.size.width, normalImage.size.height)];
        [rightButton setBackgroundImage:normalImage forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(onRightBarButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)setRightBarButtonWithString:(NSString *)rightTextString {
    if(rightTextString)
    {
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:rightTextString style:UIBarButtonItemStyleBordered target:self action:@selector(onRightBarButton:)];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (IBAction)onBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)onLeftBarButton:(id)sender {
    [applicationDelegate.viewDeckController openLeftViewAnimated:YES];
}

- (IBAction)onRightBarButton:(id)sender {
    /*
     This is the default implementation.
     */
}

@end
