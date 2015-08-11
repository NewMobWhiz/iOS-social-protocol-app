//
//  PPWebService.m
//  ProtocolPedia
//


#import "PPWebServices.h"
// JSON
#import "JSON.h"


@implementation PPWebServices

@synthesize nbRequete;
@synthesize challengeKey;
@synthesize sessionKey;
@synthesize queue;
@synthesize timeOut;
@synthesize sessionToken;

@synthesize loadingView;
@synthesize responseMsg;


static PPWebServices *instance = nil;


+ (PPWebServices *)sharedInstance {
	@synchronized(self) {
		if (instance == nil) {
			instance = [[self alloc] init];
		}
	}
	return instance;
}

- (id)init{
	if ((self = [super init])) {
        self.queue = [[NSOperationQueue alloc] init];
        nbRequete = 0;
        [self initLoadingView];
	}
	return self;
}

- (void) initLoadingView {
    //
    self.loadingView = [[UIView alloc] initWithFrame: CGRectMake(90, 140, 141, 141)];
    self.loadingView.backgroundColor = [UIColor clearColor];
    //
    UIActivityIndicatorView * ia = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
    ia.center = CGPointMake(70, 67);
    [ia startAnimating];
    [self.loadingView addSubview: ia];
    //
    UILabel * label = [[UILabel alloc] initWithFrame: CGRectMake(35, 75, 70, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.text = NSLocalizedString(@"Loading...", @"Loading Text");
    label.adjustsFontSizeToFitWidth = YES;
    [self.loadingView addSubview: label];
    
}

- (void)checkNetworkActivity {
    if (nbRequete > 0){
		[[NSThread mainThread] performBlock:^{
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            if(!self.loadingView.superview) {
                
                [applicationDelegate.viewDeckController.view addSubview: self.loadingView];
                
            }
		} waitUntilDone:NO];
	}
	else {
		[[NSThread mainThread] performBlock:^{
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [self.loadingView removeFromSuperview];
		} waitUntilDone:NO];
	}
}


-(void)connectWithLogin:(NSString *)login andPasswd:(NSString *)passwd {
    [queue addOperationWithBlock:^{
        NSURLRequest * authentificationRequest = [NSURLRequest requestWithURL: [NSURL URLWithString:[NSString stringWithFormat: @"%@?%@&username=%@&password=%@", PPBaseUrl, loginPath, login, passwd]]];
        
        NSError * errorHttp = nil;
        NSHTTPURLResponse * response = nil;
        
        nbRequete++;
        [self checkNetworkActivity];
        NSData * authentificationData = [NSURLConnection sendSynchronousRequest: authentificationRequest returningResponse: &response error: &errorHttp];
        nbRequete--;
        [self checkNetworkActivity];
        
        NSString *responseString = [[NSString alloc] initWithData:authentificationData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", responseString);
        if(response.statusCode == 200){
            
            // Create a dictionary from the JSON string
            NSError *error;
            
            SBJSON *parser = [[SBJSON alloc] init];
            NSDictionary *data = (NSDictionary *) [parser objectWithString:responseString error:&error];
            
            if (data == nil) {
                NSLog(@"%@",[NSString stringWithFormat:@"JSON parsing failed: %@", [error localizedDescription]]);
            }
            else {
                
                
                if ([[data objectForKey:@"error"] integerValue] == 1 && [[data objectForKey:@"success"] integerValue] == 0) {
                    
                    applicationDelegate.loggedIn = NO;
                    
                    [[NSThread mainThread] performBlock:^{
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:PP_NOTIFICATION_AUTHENTIFICATION_FAILED object: nil userInfo: nil];
                    
                    } waitUntilDone:NO];
                    
                }
                else if ([[data objectForKey:@"success"] integerValue] == 1){
                    
                    if ([data objectForKey:@"id"]) {
                        applicationDelegate.sessionId = [data objectForKey:@"id"];
                    }
                    applicationDelegate.loggedIn = YES;
                    applicationDelegate.loginTime = [NSDate date];
                    
                    [[NSThread mainThread] performBlock:^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:PP_NOTIFICATION_AUTHENTIFICATION_SUCCEED object: nil userInfo: nil];
                    } waitUntilDone:NO];
                }
                
            }
            
            
            
        } else
            
            [self pushConnectionAlertView];
        
    }];
}

-(void)signUpWithName:(NSString *)name andUsername:(NSString *)usernama andEmail:(NSString *)email andPassword:(NSString *)password {
    [queue addOperationWithBlock:^{
       
        NSURLRequest * signUpRequest = [NSURLRequest requestWithURL: [NSURL URLWithString:[NSString stringWithFormat: @"%@?%@&name=%@&username=%@&email=%@&password=%@", PPBaseUrl, signUpPath, name, usernama, email, password]]];
        
        NSError * errorHttp = nil;
        NSHTTPURLResponse * response = nil;
        
        nbRequete++;
        [self checkNetworkActivity];
        NSData * signUpData = [NSURLConnection sendSynchronousRequest: signUpRequest returningResponse: &response error: &errorHttp];
        nbRequete--;
        [self checkNetworkActivity];
        
        NSString *responseString = [[NSString alloc] initWithData:signUpData encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@", responseString);
        if(response.statusCode == 200){
            
            // Create a dictionary from the JSON string
            NSError *error;
            
            SBJSON *parser = [[SBJSON alloc] init];
            NSDictionary *data = (NSDictionary *) [parser objectWithString:responseString error:&error];
            
            if (data == nil) {
                NSLog(@"%@",[NSString stringWithFormat:@"JSON parsing failed: %@", [error localizedDescription]]);
            }
            else {
                
                
                if ([[data objectForKey:@"success"] integerValue] == 0) {
                    
                    self.responseMsg = [data objectForKey:@"error_msg"];
                    
                    [[NSThread mainThread] performBlock:^{
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:PP_NOTIFICATION_SIGNUP_FAILED object: nil userInfo: nil];
                        
                    } waitUntilDone:NO];
                    
                }
                else if ([[data objectForKey:@"success"] integerValue] == 1){
                    
                    [[NSThread mainThread] performBlock:^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:PP_NOTIFICATION_SIGNUP_SUCCEED object: nil userInfo: nil];
                    } waitUntilDone:NO];
                }
                
            }
            
            
            
        } else
            
            [self pushConnectionAlertView];
        
    }];
}

- (void) pushConnectionAlertView {
    [[NSThread mainThread] performBlock:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Connection Error !"
                                                        delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] ;
        [alert show];
    } waitUntilDone:NO];
    
}


@end

