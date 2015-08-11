//
//  GlobalMethods.m
//  ProtocolPedia
//
//   7/9/10.


#import "GlobalMethods.h"


@implementation GlobalMethods

//  Checking for undefined methods  //////////////


//if ([NSTextView instancesRespondToSelector:@selector(setDisplaysLinkToolTips:)])
//{
//	[myTextView setDisplaysLinkToolTips:NO];
//}
//else
//{
//	// Code to disable link tooltips with earlier technology
//}





// filepaths ///////////////////////////////////////
+ (NSString *)dataFilePathofDocuments:(NSString *)nameoffile {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:nameoffile];
	return documentsPath ;
}

+ (NSString *)dataFilePathofBundle:(NSString *)nameoffile {
	NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:nameoffile];
	return bundlePath;
}


//  Notification Messages  ///////////////////////////
+ (void) navbarStatusMessage:(NSString*)message {  // send nil message to remove
	NSNotificationCenter *navbarMessageNSNotificationCenter = [NSNotificationCenter defaultCenter];
	[navbarMessageNSNotificationCenter postNotificationName:@"NavbarStatusMessage" object:message userInfo:nil];
}

+ (void) postNotification:(NSString*)postMessage withObject:(id)thisObject {
	NSNotificationCenter *postNotificationNSNotificationCenter = [NSNotificationCenter defaultCenter];
	[postNotificationNSNotificationCenter postNotificationName:postMessage object:thisObject userInfo:nil];
}

// Global Error Alert ////////////////////
+ (void) receivedError:(NSString*)errorName {
	UIAlertView *currentAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorName delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[currentAlert show];
	
}

+ (void) displayMessage:(NSString*)messageName {
	UIAlertView *currentMessage = [[UIAlertView alloc] initWithTitle:@"Message" message:messageName delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[currentMessage show];
	
}

// date formats /////////////////////////
+ (NSDate *)zdateFromString:(NSString *)stringDate  {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:@"dd-MM-yyyy  HH.mm.ss"];  // 01-06-2010 20.43.09
    return [dateFormatter dateFromString:stringDate];
}

+ (NSString *)zstringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    return [dateFormatter stringFromDate:date];
}

///// Time

+ (NSString*) getTimeElapsedFor:(NSDate*)startTime {

	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSUInteger unitFlags = NSMinuteCalendarUnit | NSSecondCalendarUnit;
	
	NSDateComponents *components = [gregorian components:unitFlags fromDate:startTime toDate:[NSDate date] options:0];
	NSInteger minutes = [components minute];
	NSInteger seconds = [components second];
	NSString *tempString = [[NSString alloc] initWithFormat:@"%i:%i",minutes,seconds];
	return tempString;
}


//// internet connections
+ (BOOL) canConnect	{
	NSData			*dataReply;
	NSURLResponse	*response;
	NSError			*error;
	BOOL			flag;
	
	// create the request
	NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.protocolpedia.com/protocolservice/protocolservice.php"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:7.0];
	
	// Make the connection
	dataReply = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response error:&error];
	
	if (response != nil) 
	{
		flag = YES;
	} else {
		flag = NO;
		NSLog(@"%@", [error description]);
	}
	return flag;

}







@end
