//
//  ProtocolWebViewController.m
//  ProtocolPedia
//
//   7/22/10.


#import "ProtocolWebViewController.h"
#import "SQLiteAccess.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

#import "PPAppDelegate.h"


@implementation ProtocolWebViewController

@synthesize myWebView;
@synthesize protocolText;
@synthesize selectedProtocolId;

-(void) loadAd {
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    
    UIImage *backImage = [UIImage imageNamed:@"btn_back.png"];
    [self setBackButton:backImage];
    
	NSString *selectProtocol = [NSString stringWithFormat:@"SELECT ProtocolId, Title, Text, Credit, NumberOfReviews, Stars FROM Protocols WHERE ProtocolId = \"%@\"",self.selectedProtocolId];
	
	NSDictionary *tempDict = [[NSDictionary alloc] initWithDictionary:[SQLiteAccess selectOneRowWithSQL:selectProtocol]];

	int intStars = [[tempDict objectForKey:@"Stars"] intValue];
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
	NSString *imageFile;
	
	switch (intStars) {
		case 0:
			imageFile = @"<img src=\"0Stars.png\">";
			break;
		case 1:
			imageFile = @"<img src=\"1Stars.png\">";
			break;
		case 2:
			imageFile = @"<img src=\"2Stars.png\">";
			break;
		case 3:
			imageFile = @"<img src=\"3Stars.png\">";
			break;
		case 4:
			imageFile = @"<img src=\"4Stars.png\">";
			break;
		case 5:
			imageFile = @"<img src=\"5Stars.png\">";
			break;
		default:
			imageFile = @"<img src=\"0Stars.png\">";
			break;
	}


	NSString *tempString = [NSString stringWithFormat:
							@"%@%@%@%@%@%@%@%@%@%@%@",
							@"<P><B><FONT SIZE=3>",
							[tempDict objectForKey:@"Title"],
							@"</B></FONT></P><P>Credit: ",
							[tempDict objectForKey:@"Credit"],
							@"</P><P>Number of Reviews: ",
							[tempDict objectForKey:@"NumberOfReviews"],
							@"</P>",
							@"<P>",
							imageFile,
							@"</P>",
							[tempDict objectForKey:@"Text"]
							];
	self.protocolText = tempString;
	[self.myWebView loadHTMLString:self.protocolText baseURL:baseURL];
    //////////////////
    float wDevice = 320;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        wDevice = 768;
    }
    else{
        wDevice = 320;
    }
    
    
    
//    UIButton *facebookButton = [[UIButton alloc] initWithFrame:CGRectMake(wDevice - 42, 11, 32, 27)] ;
//    [facebookButton setImage:[UIImage imageNamed:@"FacebookSelected.png"] forState:UIControlStateNormal];
//    [facebookButton addTarget:self action:@selector(loadFaceBook:) forControlEvents:UIControlEventTouchUpInside];
//    [viewHeader addSubview:facebookButton];
    
    UIBarButtonItem *facebookBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"FacebookSelected.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(loadFaceBook:)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = facebookBarItem;
    
    
    ////////////
    appDelegate = [[UIApplication sharedApplication]delegate];
    if (!appDelegate.session.isOpen) {
        appDelegate.session = [[FBSession alloc] init];
        
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
            }];
        }
    }
    
}


#pragma mark Dismiss Mail/SMS view controller

- (void)mailComposeController:(MFMailComposeViewController*)controller

          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    [self dismissModalViewControllerAnimated:YES];
}
//////////
-(void) loadFaceBook:(id)sender {
    appDelegate = [[UIApplication sharedApplication]delegate];
    
    if (appDelegate.session.isOpen) {
        [appDelegate.session closeAndClearTokenInformation];
        
    } else {
        if (appDelegate.session.state != FBSessionStateCreated) {
            appDelegate.session = [[FBSession alloc] init];
        }
        
        [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
        }];
    }
    NSLog(@"Log facebook!");
    
}

-(void)displayMailComposerSheet:(NSString *) toReceive Subject:(NSString *) strSubject Body:(NSString *) strBody

{
    
    __autoreleasing MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:strSubject];
    
    // Set up recipients
    
    NSArray *toRecipients = [NSArray arrayWithObject:toReceive];
    
    [picker setToRecipients:toRecipients];
    
    [picker setCcRecipients:nil];
    
    [picker setBccRecipients:nil];
    
    NSString *emailBody = @"";
    
    [picker setMessageBody:emailBody isHTML:NO];
//    [picker addAttachmentData:UIImagePNGRepresentation([self returnImage]) mimeType:@"image/png" fileName:@"eventname.png"];
    
    [self presentModalViewController:picker animated:YES];
    
}

-(void)openShare{
    if ([popShare isBeingPresented]) {
        [popShare dismissPopoverAnimatd:YES];
    }
    else{
        int count = 4;
        BOOL flag = NO;
        UIViewController *tmpController = [[UIViewController alloc] init];
        tmpController.view.frame = CGRectMake(0, 0, 46, 46 * count);
        
        if (flag) {
            __autoreleasing UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 46, 46)];
            [btn2 setImage:[UIImage imageNamed:@"Facebook.png"] forState:UIControlStateNormal];
            [btn2 addTarget:self action:@selector(shareFacebook) forControlEvents:UIControlEventTouchUpInside];
            [tmpController.view addSubview:btn2];
            
            __autoreleasing UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 46, 46, 46)];
            [btn3 setImage:[UIImage imageNamed:@"Twitter.png"] forState:UIControlStateNormal];
            [btn3 addTarget:self action:@selector(shareTwitter) forControlEvents:UIControlEventTouchUpInside];
            [tmpController.view addSubview:btn3];
            
            __autoreleasing UIButton *btn4 = [[UIButton alloc] initWithFrame:CGRectMake(0, 46 * 2, 46, 46)];
            [btn4 setImage:[UIImage imageNamed:@"Email.png"] forState:UIControlStateNormal];
            [btn4 addTarget:self action:@selector(shareEmail) forControlEvents:UIControlEventTouchUpInside];
            [tmpController.view addSubview:btn4];
        }
        else{
            __autoreleasing UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 46, 46)];
            [btn1 setImage:[UIImage imageNamed:@"Favourite.png"] forState:UIControlStateNormal];
            [btn1 addTarget:self action:@selector(addToFavorite) forControlEvents:UIControlEventTouchUpInside];
            [tmpController.view addSubview:btn1];
            
            __autoreleasing UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 46, 46, 46)];
            [btn2 setImage:[UIImage imageNamed:@"Facebook.png"] forState:UIControlStateNormal];
            [btn2 addTarget:self action:@selector(shareFacebook) forControlEvents:UIControlEventTouchUpInside];
            [tmpController.view addSubview:btn2];
            
            __autoreleasing UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 46 * 2, 46, 46)];
            [btn3 setImage:[UIImage imageNamed:@"Twitter.png"] forState:UIControlStateNormal];
            [btn3 addTarget:self action:@selector(shareTwitter) forControlEvents:UIControlEventTouchUpInside];
            [tmpController.view addSubview:btn3];
            
            __autoreleasing UIButton *btn4 = [[UIButton alloc] initWithFrame:CGRectMake(0, 46 * 3, 46, 46)];
            [btn4 setImage:[UIImage imageNamed:@"Email.png"] forState:UIControlStateNormal];
            [btn4 addTarget:self action:@selector(shareEmail) forControlEvents:UIControlEventTouchUpInside];
            [tmpController.view addSubview:btn4];
        }
        
        popShare = [[TSPopoverController alloc] initWithContentViewController: tmpController];
        popShare.cornerRadius = 5;
        popShare.popoverBaseColor = [UIColor colorWithRed:60.0/255 green:60.0/255 blue:60.0/255 alpha:1.0];
        popShare.popoverGradient = YES;
        popShare.arrowPosition = TSPopoverArrowPositionVertical;
        
        [popShare showPopoverWithRect:CGRectMake(btnShare.frame.origin.x + 343, btnShare.frame.origin.y + 25, 1, 1)];
    }
}

-(void)addToFavorite{
    [popShare dismissPopoverAnimatd:YES];
}

-(void)shareFacebook{
    [popShare dismissPopoverAnimatd:YES];
    
    Class fClass = (NSClassFromString(@"SLComposeViewController"));
    
    if (fClass != nil) {
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
                if (result == SLComposeViewControllerResultCancelled) {
                    
                    NSLog(@"Cancelled");
                    
                } else
                {
                    NSLog(@"Done");
                }
                
                [controller dismissViewControllerAnimated:YES completion:Nil];
            };
            controller.completionHandler = myBlock;
            
            [controller setInitialText:[NSString stringWithFormat:@"I am doing better science using %@ from the Protocolpedia app.", self.protocolName]];
            [controller addURL:[NSURL URLWithString:@"www.eventname.com"]];
//            [controller addImage:[self returnImage]];
            
            [self presentViewController:controller animated:YES completion:Nil];
        }
    }
}

-(void)shareTwitter{
    [popShare dismissPopoverAnimatd:YES];
    
    Class fClass = (NSClassFromString(@"SLComposeViewController"));
    
    if (fClass != nil) {
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            
            SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
                if (result == SLComposeViewControllerResultCancelled) {
                    
                    NSLog(@"Cancelled");
                    
                } else
                {
                }
                
                [controller dismissViewControllerAnimated:YES completion:Nil];
            };
            controller.completionHandler = myBlock;
            
            [controller setInitialText:[NSString stringWithFormat:@"I am doing better science using %@ from the Protocolpedia app.", self.protocolName]];
            [controller addURL:[NSURL URLWithString:@"www.eventname.com"]];
//            [controller addImage:[self returnImage]];
            
            [self presentViewController:controller animated:YES completion:Nil];
        }
    }
    
    
}

-(void)shareEmail{
    [popShare dismissPopoverAnimatd:YES];
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
    if (mailClass != nil) {
        if ([mailClass canSendMail]) {
            [self displayMailComposerSheet:@"" Subject:[NSString stringWithFormat:@"I am doing better science using %@ from the Protocolpedia app.", self.protocolName] Body:@""];
        }
        
        else {
            __autoreleasing UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Device not configured to send mail." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    else {
        __autoreleasing UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Device not configured to send mail." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}



@end
