//
//  ImageViewController.m
//  ProtocolPedia
//
//   9/17/10.


#import "ImageViewController.h"


@implementation ImageViewController

@synthesize thisWebview;
@synthesize imageURLString;
@synthesize activityIndicator;


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
	
	self.activityIndicator.frame = CGRectMake(135, 175, 50, 50);
	
//NSLog(@"self.imageURLString %@",self.imageURLString);

	NSURL *thisImageURL = [NSURL URLWithString:self.imageURLString];
	NSURLRequest *thisImageRequest = [NSURLRequest requestWithURL:thisImageURL];
	[self.thisWebview loadRequest:thisImageRequest];

	
	
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	NSLog(@"image webView didFailLoadWithError");

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
//NSLog(@"webViewDidFinishLoad");
	self.activityIndicator.hidden = YES;
	[self.activityIndicator stopAnimating];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	self.activityIndicator.hidden = NO;
	[self.activityIndicator startAnimating];
	
//NSLog(@"webViewDidStartLoad");

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
