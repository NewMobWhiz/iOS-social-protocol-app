//
//  VideoWebViewController.m
//  ProtocolPedia
//
//   7/29/10.


#import "VideoWebViewController.h"
#import "SQLiteAccess.h"


@implementation VideoWebViewController

@synthesize videoWebView;
@synthesize selectedVideoId;


-(void) loadAd {
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *backImage = [UIImage imageNamed:@"btn_back.png"];
    [self setBackButton:backImage];
    
	NSString *selectVideo = [NSString stringWithFormat:@"SELECT Video_Id, VideoType FROM Videos WHERE VideoId = \"%@\"",self.selectedVideoId];
	NSDictionary *tempDict = [[NSDictionary alloc] initWithDictionary:[SQLiteAccess selectOneRowWithSQL:selectVideo]];
	//NSLog(@"[tempDict objectForKey:@\"VideoType\"] %@",[tempDict objectForKey:@"VideoType"]);

	NSString *tempString1 = [NSString stringWithFormat:@"http://www.%@/watch?v=%@",[tempDict objectForKey:@"VideoType"],[tempDict objectForKey:@"Video_Id"]];
//	NSString *tempString2 = [NSString stringWithFormat:@"/watch?v=%@",[tempDict objectForKey:@"Video_Id"]];
	NSURLRequest *URLRequestTemp = [NSURLRequest requestWithURL:[NSURL URLWithString:tempString1]];
	
	
//	[self.videoWebView loadHTMLString:tempString1 baseURL:nil]; 
	
	[self.videoWebView loadRequest:URLRequestTemp];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation ==UIInterfaceOrientationPortraitUpsideDown);
}


-(BOOL) shouldAutorotate{
    return YES;
}

-(NSUInteger) supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}





@end
