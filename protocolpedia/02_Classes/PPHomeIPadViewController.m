//
//  PPHomeIPadViewController.m
//  ProtocolPedia
//


#import "PPHomeIPadViewController.h"
#import "GHMenuCell.h"
#import "PPHomeViewController.h"
#import "UIViewEnhanced.h"
#import "SignIn.h"
#import "SignUp.h"

@interface PPHomeIPadViewController ()<SignInWSDelegate, SignUpWSDelegate>
- (void)revealSidebar;

@end

@implementation PPHomeIPadViewController

@synthesize appDelegate;

- (void)revealSidebar {
	_revealBlock();
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withRevealBlock:(RevealBlock)revealBlock{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _revealBlock = [revealBlock copy];
        
        float wDevice = 320;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            wDevice = 768;
        }
        else{
            wDevice = 320;
        }
        
        self.navigationController.navigationBarHidden = YES;
        viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wDevice, 50)];
        viewHeader.backgroundColor = [UIColor colorWithRed:46.0/255 green:133.0/255 blue:189.0/255 alpha:1.0];
        [self.view addSubview:viewHeader];
        
        /*UIButton *btnBack = [[[UIButton alloc] initWithFrame:CGRectMake(10, 5, 46, 40)] autorelease];
        [btnBack setImage:[UIImage imageNamed:@"icn_menu_main.png"] forState:UIControlStateNormal];
        [btnBack addTarget:self action:@selector(revealSidebar) forControlEvents:UIControlEventTouchUpInside];
        [viewHeader addSubview:btnBack];
        */
        UILabel *lb1 = [[UILabel alloc] initWithFrame:CGRectMake(86, 0, 200, 30)];
        lb1.textColor = [UIColor whiteColor];
        lb1.backgroundColor = [UIColor clearColor];
        lb1.font = [UIFont fontWithName:@"Arial" size:18];
        lb1.text = @"Protocol Pedia";
        [viewHeader addSubview:lb1];
        
        UILabel *lb2 = [[UILabel alloc] initWithFrame:CGRectMake(86, 25, 250, 20)];
        lb2.textColor = [UIColor whiteColor];
        lb2.backgroundColor = [UIColor clearColor];
        lb2.font = [UIFont fontWithName:@"Arial" size:14];
        lb2.text = @"The encyclopedia of lab protocols";
        [viewHeader addSubview:lb2];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    UIColor *myColor = [UIColor colorWithRed:([[self.appDelegate.settings objectForKey:@"Red"] floatValue]/255.0) green:([[self.appDelegate.settings objectForKey:@"Green"] floatValue]/255.0) blue:([[self.appDelegate.settings objectForKey:@"Blue"] floatValue]/255.0) alpha:1.0];
    UIColor *myTintColor = [UIColor colorWithRed:([[self.appDelegate.settings objectForKey:@"TintRed"] floatValue]/255.0) green:([[self.appDelegate.settings objectForKey:@"TintGreen"] floatValue]/255.0) blue:([[self.appDelegate.settings objectForKey:@"TintBlue"] floatValue]/255.0) alpha:1.0];
    self.navigationController.navigationBar.tintColor = myTintColor;
    viewHeader.backgroundColor = myTintColor;
    self.view.backgroundColor = myColor;
    
    [tabs refreshColor];
    
    [tabs touchUpInsideActionWithNoButton];
    [self touchUpInsideTabIndex:0];
    
    [self.view findAndResignFirstResponder];
    
    _viewSignUp.hidden = YES;
}

#pragma mark SlidingTabsControl Delegate
- (UILabel*) labelFor:(SlidingTabsControl*)slidingTabsControl atIndex:(NSUInteger)tabIndex;
{
    UILabel* label = [[UILabel alloc] init];
    label.font = [UIFont fontWithName:@"Arial" size:12];
    if (tabIndex == 0) {
        label.text = @"LOGIN";
    }
    else if (tabIndex == 1) {
        label.text = @"SIGN UP";
    }
    else if (tabIndex == 2) {
        label.text = @"ABOUT";
    }
    
    return label;
}

- (void) touchUpInsideTabIndex:(NSUInteger)tabIndex
{
    if (tabIndex == 0) {
        _viewLogin.hidden = NO;
        _viewRegister.hidden = YES;
        _viewTour.hidden = YES;
    }
    else if (tabIndex == 1) {
        _viewLogin.hidden = YES;
        _viewRegister.hidden = NO;
        _viewTour.hidden = YES;
        
        _viewSignUp.hidden = YES;
    }
    else if (tabIndex == 2) {
        _viewLogin.hidden = YES;
        _viewRegister.hidden = YES;
        _viewTour.hidden = NO;
    }
    
    [self.view findAndResignFirstResponder];
}

- (void) touchDownAtTabIndex:(NSUInteger)tabIndex
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = (PPAppDelegate*)[[UIApplication sharedApplication]delegate];
    
    tabs = [[SlidingTabsControl alloc] initWithTabCount:3 delegate:self];
    float wDevice = 320;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        wDevice = 768;
    }
    else{
        wDevice = 320;
    }
    tabs.frame = CGRectMake(0, 50, wDevice, tabs.frame.size.height);
    [self.view addSubview:tabs];
    
}

- (IBAction)touchFirstResponder:(id)sender {
    [self.view findAndResignFirstResponder];
}

- (IBAction)agreeTerms:(id)sender {
    if (_flagTerms) {
        _flagTerms = NO;
        [_icnTerms setImage:[UIImage imageNamed:@"icon_check_normal.png"] forState:UIControlStateNormal];
    }
    else{
        _flagTerms = YES;
        [_icnTerms setImage:[UIImage imageNamed:@"icon_check_bold.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)openSignupView:(id)sender {
    _viewSignUp.hidden = NO;
}

-(BOOL) nsStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (IBAction)loginClicked:(id)sender {
    //    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    //        [self dismissModalViewControllerAnimated:YES];
    //    }
    if ([_login_username.text isEqualToString:@""])
    {
        UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"ProtocolPedia" message:@"Username is required!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert1 show];
        return;
    }
    else if ([_login_pass.text isEqualToString:@""])
    {
        UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"ProtocolPedia" message:@"Password is required!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert1 show];
        return;
    }
    else
    {
        SignIn *signIn = [[SignIn alloc]init];
        signIn.delegate = self;
        [signIn startThreadLogin:_login_username.text :_login_pass.text];
    }
}

- (IBAction)signUpClicked:(id)sender {
    //    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    //        [self dismissModalViewControllerAnimated:YES];
    //    }
    if ([_register_firstname.text isEqualToString:@""]) {
        UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"ProtocolPedia" message:@"First name is required!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert1 show];
        return;
    }
    else if ([_register_lastname.text isEqualToString:@""]) {
        UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"ProtocolPedia" message:@"Last name is required!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert1 show];
        return;
    }
    else if ([_register_username.text isEqualToString:@""]) {
        UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"ProtocolPedia" message:@"Username is required!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert1 show];
        return;
    }
    else if ([_register_password.text isEqualToString:@""]) {
        UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"ProtocolPedia" message:@"Password is required!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert1 show];
        return;
    }
    else if (![self nsStringIsValidEmail:_register_email.text]) {
        UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"ProtocolPedia" message:@"The email doesn't exist or incorrect. Please input the email again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert1 show];
        return;
    }
    else
    {
        if (_flagTerms) {
            SignUp *signUp = [[SignUp alloc]init];
            signUp.delegate = self;
            NSString *name = [NSString stringWithFormat:@"%@ %@", _register_firstname.text, _register_lastname.text];
            [signUp startThreadLogin:name :_register_email.text :_register_username.text :_register_password.text];
        }
        else
        {
            UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"ProtocolPedia" message:@"Please read and agree to Protocolpedia's term and conditions" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert1 show];
            return;
        }
    }
}

-(void)viewDidAppear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - SignInWSDelegate

-(void) SignInSuccess: (int)userID
{
    NSLog(@"userID:%i", userID);
}

-(void) SignInFailed
{
    NSLog(@"Signin failed");
}

#pragma mark - SignUpWSDelegate

-(void) SignUpSuccess: (int)userID
{
    NSLog(@"userID:%i", userID);
}

-(void) SignUpFailed
{
    NSLog(@"Register failed!");
}

@end
