//
//  PPHomeViewController.m
//  ProtocolPedia
//


#import "PPHomeViewController.h"

#import "PPProtocolCategoriesViewController.h"
#import "PPWebServices.h"
#import "UIViewEnhanced.h"
#import "AboutViewController.h"
///
#define AdMob_ID @"ca-app-pub-4786348679245811/4886726460" // You can get this id from www.admob.com. This is Publisher ID

#define kRemoveAdsProductIdentifier @"put your product id (the one that we just made in iTunesConnect) in here"

@interface PPHomeViewController ()

@end


@implementation PPHomeViewController


- (IBAction)openSignUpView:(id)sender {
    _viewSignUp.hidden = NO;
}

- (IBAction)ClickHelp:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:1 forKey:@"BackInfo"];
    [defaults synchronize];
    AboutViewController *aboutVC = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
    [applicationDelegate.navigationController setViewControllers:[NSArray arrayWithObject:aboutVC] animated:NO];
    [applicationDelegate.viewDeckController closeOpenViewAnimated:YES];
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
        
        [[PPWebServices sharedInstance] connectWithLogin:_login_username.text andPasswd:_login_pass.text];
    }
}

- (IBAction)signUpClicked:(id)sender {

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
        
            NSString *name = [[NSString stringWithFormat:@"%@ %@", _register_firstname.text, _register_lastname.text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[PPWebServices sharedInstance] signUpWithName:name andUsername:_register_username.text andEmail:_register_email.text andPassword:_register_password.text];
            
        }
        else
        {
            UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"ProtocolPedia" message:@"Please read and agree to Protocolpedia's term and conditions" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert1 show];
            return;
        }
    }
}

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
    

    
/////in app purchase ///
    areAdsRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:@"areAddsRemoved"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //this will load wether or not they bought the in-app purchase
    
    if(areAdsRemoved){
        [self.view setBackgroundColor:[UIColor blueColor]];
        //if they did buy it, set the background to blue, if your using the code above to set the background to blue, if your removing ads, your going to have to make your own code here
    }
    // Subscribe to notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoginSucceed) name:PP_NOTIFICATION_AUTHENTIFICATION_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoginFailed) name:PP_NOTIFICATION_AUTHENTIFICATION_FAILED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSignUpSucceed) name:PP_NOTIFICATION_SIGNUP_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSignUpFailed) name:PP_NOTIFICATION_SIGNUP_FAILED object:nil];
    
    
    applicationDelegate.viewDeckController.panningMode = IIViewDeckNoPanning;
    
    tabs = [[SlidingTabsControl alloc] initWithTabCount:2 delegate:self];
    float wDevice = 320;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        wDevice = 768;
    }
    else{
        wDevice = 320;
    }
    tabs.frame = CGRectMake(0, 0, wDevice, tabs.frame.size.height);
    [self.view addSubview:tabs];
    
    //////////admob////////
//    AbMob = [[GADBannerView alloc]
//             initWithFrame:CGRectMake(0.0,
//                                      self.view.frame.size.height -
//                                      GAD_SIZE_320x50 .height,
//                                      GAD_SIZE_320x50 .width,
//                                      GAD_SIZE_320x50 .height)];
//    
//    AbMob.adUnitID = AdMob_ID;
//    AbMob.rootViewController = self;
//    [self.view addSubview:AbMob];
//    
//    GADRequest *r = [[GADRequest alloc] init];
//    r.testDevices = @[GAD_SIMULATOR_ID ];
//    [AbMob loadRequest:r];
    
    NSLog(@"ADMob Success");
    ////////////
    
    _login_username.keyTextField = @"login";
    _login_username.returnKeyType = UIReturnKeyNext;
    _login_pass.keyTextField = @"login";
    _login_pass.returnKeyType = UIReturnKeyGo;
    
    _register_firstname.keyTextField = @"register";
    _register_firstname.returnKeyType = UIReturnKeyNext;
    _register_lastname.keyTextField = @"register";
    _register_lastname.returnKeyType = UIReturnKeyNext;
    _register_email.keyTextField = @"register";
    _register_email.returnKeyType = UIReturnKeyNext;
    _register_username.keyTextField = @"register";
    _register_username.returnKeyType = UIReturnKeyNext;
    _register_password.keyTextField = @"register";
    _register_password.returnKeyType = UIReturnKeyGo;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _flagTerms = NO;
}

-(void)_keyboardWillShow:(NSNotification *)notf{
    
}

-(void)_keyboardWillHide:(NSNotification *)notf{
    [UIView animateWithDuration:0.3 animations:^{
        _viewLogin.frame = CGRectMake(0, 60, 320, _viewLogin.frame.size.height);
        _viewSignUp.frame = CGRectMake(0, 60, _viewSignUp.frame.size.width, _viewSignUp.frame.size.height);
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [tabs refreshColor];
    
    [tabs touchUpInsideActionWithNoButton];
    [self touchUpInsideTabIndex:0];
    
    //_viewSignUp.hidden = YES;
    
    [self.view findAndResignFirstResponder];
    [self touchUpInsideTabIndex:self.tabIndex];
}

-(void)viewDidAppear:(BOOL)animated{
    //_viewLogin.center = self.view.center;
    //_viewRegister.center = self.view.center;
    _viewTour.center = self.view.center;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark SlidingTabsControl Delegate

- (UILabel*) labelFor:(SlidingTabsControl*)slidingTabsControl atIndex:(NSUInteger)tabIndex;
{
    UILabel* label = [[UILabel alloc] init] ;
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
        _viewSignUp.hidden = YES;
        _viewTour.hidden = YES;
    }
    else if (tabIndex == 1) {
        _viewLogin.hidden = YES;
        _viewRegister.hidden = NO;
        _viewSignUp.hidden = NO;
        _viewTour.hidden = YES;
        
        //_viewSignUp.hidden = YES;
    }
    else if (tabIndex == 2) {
        _viewLogin.hidden = YES;
        _viewRegister.hidden = YES;
        _viewSignUp.hidden = YES;
        _viewTour.hidden = NO;
    }
    
    [self.view findAndResignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == _login_username || textField == _login_pass) {
        [UIView animateWithDuration:0.3 animations:^{
            _viewLogin.frame = CGRectMake(0, 20, 320, _viewLogin.frame.size.height);
        }];
        
    }
    else if (!_viewRegister.hidden) {
        [UIView animateWithDuration:0.3 animations:^{
            _viewSignUp.frame = CGRectMake(0, 20, _viewSignUp.frame.size.width, _viewSignUp.frame.size.height);
        }];
        
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void) touchDownAtTabIndex:(NSUInteger)tabIndex
{
    
}

#pragma mark - SignInWSDelegate

-(void) onLoginSucceed
{
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setValue:_login_username.text forKey:kPPUsername];
        [standardUserDefaults setValue:_login_pass.text forKey:kPPPassword];
        [standardUserDefaults synchronize];
    }
    applicationDelegate.loggedIn = YES;
    applicationDelegate.username = _login_username.text;
    
        PPProtocolCategoriesViewController *protocolCategoriesVC = [[PPProtocolCategoriesViewController alloc] initWithNibName:@"PPProtocolCategoriesViewController" bundle:nil];
        
        [applicationDelegate.navigationController setViewControllers:[NSArray arrayWithObject:protocolCategoriesVC] animated:NO];
        [applicationDelegate.viewDeckController closeOpenViewAnimated:YES];
//    [self.navigationController popViewControllerAnimated:YES];
}

-(void) onLoginFailed
{
    UIAlertView *alert = [[UIAlertView alloc ] initWithTitle:@"ProtocolPedia" message:@"The username or password you entered is incorrect." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void)onSignUpSucceed {
    
    [tabs refreshColor];
    
    [tabs touchUpInsideActionWithNoButton];
    [self touchUpInsideTabIndex:0];
    
    UIAlertView *alert = [[UIAlertView alloc ] initWithTitle:@"ProtocolPedia" message:@"Sing up succeed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}


- (void)onSignUpFailed {
    UIAlertView *alert = [[UIAlertView alloc ] initWithTitle:@"ProtocolPedia" message:[[PPWebServices sharedInstance] responseMsg] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}
/////// in app purchase /////


- (void)tapsRemoveAds{
    NSLog(@"User requests to remove ads");
    
    if([SKPaymentQueue canMakePayments]){
        NSLog(@"User can make payments");
        
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kRemoveAdsProductIdentifier]];
        productsRequest.delegate = self;
        [productsRequest start];
        
    }
    else{
        NSLog(@"User cannot make payments due to parental controls");
        //this is called the user cannot make payments, most likely due to parental controls
    }
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    SKProduct *validProduct = nil;
    int count = [response.products count];
    if(count > 0){
        validProduct = [response.products objectAtIndex:0];
        NSLog(@"Products Available!");
        [self purchase:validProduct];
    }
    else if(!validProduct){
        NSLog(@"No products available");
        //this is called if your product id is not valid, this shouldn't be called unless that happens.
    }
}

- (IBAction)purchase:(SKProduct *)product{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (IBAction) restore{
    //this is called when the user restores purchases, you should hook this up to a button
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}
- (void)doRemoveAds{
    GADBannerView *banner;
    [banner setAlpha:0];
    areAdsRemoved = YES;
//    removeAdsButton.hidden = YES;
//    removeAdsButton.enabled = NO;
    [[NSUserDefaults standardUserDefaults] setBool:areAdsRemoved forKey:@"areAdsRemoved"];
    //use NSUserDefaults so that you can load wether or not they bought it
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"received restored transactions: %i", queue.transactions.count);
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        if(SKPaymentTransactionStateRestored){
            NSLog(@"Transaction state -> Restored");
            //called when the user successfully restores a purchase
            [self doRemoveAds];
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            break;
        }
        
    }
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    for(SKPaymentTransaction *transaction in transactions){
        switch (transaction.transactionState){
            case SKPaymentTransactionStatePurchasing: NSLog(@"Transaction state -> Purchasing");
                //called when the user is in the process of purchasing, do not add any of your own code here.
                break;
            case SKPaymentTransactionStatePurchased:
                //this is called when the user has successfully purchased the package (Cha-Ching!)
                [self doRemoveAds]; //you can add your code for what you want to happen when the user buys the purchase here, for this tutorial we use removing ads
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSLog(@"Transaction state -> Purchased");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Transaction state -> Restored");
                //add the same code as you did from SKPaymentTransactionStatePurchased here
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                //called when the transaction does not finnish
                if(transaction.error.code != SKErrorPaymentCancelled){
                    NSLog(@"Transaction state -> Cancelled");
                    //the user cancelled the payment ;(
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
        }
    }
}

@end
