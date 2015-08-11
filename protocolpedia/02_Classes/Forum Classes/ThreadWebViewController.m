//
//  ThreadWebViewController.m
//  ProtocolPedia
//
//   9/28/10.


#import "ThreadWebViewController.h"
#import "SQLiteAccess.h"
#import "AddThreadViewController.h"

@implementation ThreadWebViewController
@synthesize threadWebview;
@synthesize threadId;

@synthesize menuItems;
@synthesize threadTitle;


- (void)viewDidLoad {
    [super viewDidLoad];
	
		self.menuItems = (NSMutableArray*)[SQLiteAccess selectManyRowsWithSQL:[NSString stringWithFormat:@"SELECT * FROM Discussions WHERE ThreadId = \"%@\" ORDER BY SubmittedDate",self.threadId]];
	
	// set add Post button for this view	
	UIBarButtonItem *addPostBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStyleBordered target:self action:@selector(addThread:)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
	self.navigationItem.rightBarButtonItem = addPostBarItem;
	
	UIImage *backImage = [UIImage imageNamed:@"btn_back.png"];
    [self setBackButton:backImage];
    
    NSNotificationCenter *myNotificationCenter = [NSNotificationCenter defaultCenter];
	[myNotificationCenter addObserver:self selector:@selector(reloadTable:) name:@"AddTopic" object:nil];
	[self createWebView];
	
    float wDevice = 320;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        wDevice = 768;
    }
    else{
        wDevice = 320;
    }
    self.threadWebview.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    
    //[self.tableViewOutlet setBackgroundView:nil];
}

-(void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

}

-(void) reloadTable:(NSNotification*)notification {
	self.menuItems = (NSMutableArray*)[SQLiteAccess selectManyRowsWithSQL:[NSString stringWithFormat:@"SELECT * FROM Discussions WHERE ThreadId = \"%@\" ORDER BY SubmittedDate",self.threadId]];
	[self createWebView];
	
}


- (NSArray *)search:(NSString *)tagName endTagName:(NSString *)_endTagName dataStr:(NSString *)_dataStr{	
	NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:10];
	
	int beginIndex = 0;
	int totalLength = [_dataStr length];
	NSString *startDelimeter = [NSString stringWithFormat:@"%@", tagName];
	NSString *endDelimeter	 = [NSString stringWithFormat:@"%@", _endTagName];
	
	while (beginIndex < totalLength) {
		
		int length = totalLength - beginIndex;
		NSRange resultRange1, searchRange1, range, resultRange2, searchRange2;
		
		searchRange1.location = beginIndex;	searchRange1.length = length;
		resultRange1 = [_dataStr rangeOfString:startDelimeter options:NSCaseInsensitiveSearch range:searchRange1];
		
		if (resultRange1.location == NSNotFound) break;
		
		searchRange2.location = resultRange1.location + [startDelimeter length];
		searchRange2.length = totalLength - searchRange2.location;
		resultRange2 = [_dataStr rangeOfString:endDelimeter options:NSCaseInsensitiveSearch range:searchRange2];
		
		range.location = resultRange1.location + [startDelimeter length];
		range.length = resultRange2.location - range.location;
		
		[arr addObject:[_dataStr substringWithRange:range]];
		beginIndex = resultRange2.location + [endDelimeter length];
	}
	return arr;
}

-(NSString*)msgFilter:(NSString*)msg {
	NSArray *arr = [self search:@"<url=" endTagName:@"</url>" dataStr:msg];
	
	NSMutableArray *urlArr = [[NSMutableArray alloc] init];
	NSMutableArray *strArr = [[NSMutableArray alloc] init];
	
	NSString *filteredMsg = [NSString stringWithString:msg];
	
	for (int i = 0; i < [arr count]; i++) {
		NSString *eleStr = [arr objectAtIndex:i];
		NSArray *eleArr = [eleStr componentsSeparatedByString:@">"];
		
		[urlArr addObject:[eleArr objectAtIndex:0]];
		[strArr addObject:[eleArr objectAtIndex:1]];
		filteredMsg = [filteredMsg stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<url=%@/>%@</url>", [eleArr objectAtIndex:0], [eleArr objectAtIndex:1]] withString:[eleArr objectAtIndex:1]];
	}
	
	for (int i = 0; i < [arr count]; i++) {
		filteredMsg = [filteredMsg stringByReplacingOccurrencesOfString:[strArr objectAtIndex:i] withString:[NSString stringWithFormat:@"<a href='%@'>%@</a>", [urlArr objectAtIndex:i], [strArr objectAtIndex:i]]];
	}
	return filteredMsg;
}

-(void) createWebView {
	NSMutableString *tempWebViewString = [NSMutableString string];

	for (id item in self.menuItems) {
		tempWebViewString = [NSMutableString stringWithString:[tempWebViewString stringByAppendingFormat:@"<p><big><b>%@</b></big><br />%@<p></p>",[item objectForKey:@"Subject"],[item objectForKey:@"SubmittedBy"]]];
		tempWebViewString = [NSMutableString stringWithString:[tempWebViewString stringByAppendingFormat:@"%@<br />Hits: %@<p></p>",[GlobalMethods zstringFromDate:[NSDate dateWithTimeIntervalSince1970:[[item objectForKey:@"SubmittedDate"]intValue]]],[item objectForKey:@"NumberOfHits"]]];
		tempWebViewString = [NSMutableString stringWithString:[tempWebViewString stringByAppendingString:[self msgFilter:[item objectForKey:@"MessageText"]]]];
		tempWebViewString = [NSMutableString stringWithString:[tempWebViewString stringByAppendingString:@"<p></p><p></p>-----------------------------<p></p><p></p>"]];
	}

	[self.threadWebview loadHTMLString:[NSString stringWithString:tempWebViewString] baseURL:nil];

	
}




-(void) addThread:(id)sender {
	if (applicationDelegate.loggedIn == YES) {
		if (applicationDelegate.addingTopic == NO) {
			AddThreadViewController *addThreadViewController = [[AddThreadViewController alloc] initWithNibName:@"AddThreadViewController" bundle:nil];
			addThreadViewController.threadId = self.threadId;
			addThreadViewController.threadTitle = self.threadTitle;
            //		addThreadViewController.subjectText = [NSString stringWithFormat:@"RE: %@",self.subject];
			[[self navigationController] pushViewController:addThreadViewController animated:YES];
			
		} else {
			[GlobalMethods displayMessage:@"Currently Adding Reply"];
		}
	} else {
		[GlobalMethods displayMessage:@"You must be logged in to reply to thread"];
	}
	
}




#pragma mark ADBannerViewDelegate methods
/*
- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
	if (!self.bannerIsVisible) {
		[UIView beginAnimations:@"animateAdBannerOn" context:NULL];
		// banner is invisible now and moved out of the screen on 50 px
		banner.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, 50.0);
		self.threadWebview.frame = CGRectMake(0.0, 50.0, self.view.frame.size.width, self.view.frame.size.height - 50.0);
		[UIView commitAnimations];
		self.bannerIsVisible = YES;
	}
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
	if (self.bannerIsVisible) {
		[UIView beginAnimations:@"animateAdBannerOff" context:NULL];
		// banner is visible and we move it out of the screen, due to connection issue
		banner.frame = CGRectMake(0.0, -50.0, self.view.frame.size.width, 50.0);
		self.threadWebview.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
		[UIView commitAnimations];
		self.bannerIsVisible = NO;
	}
}
*/

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
