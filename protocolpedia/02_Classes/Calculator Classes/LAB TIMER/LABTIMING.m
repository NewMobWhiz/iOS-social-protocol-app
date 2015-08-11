//
//  LABTIMING.m
//  ProtocolPedia
//


#import "LABTIMING.h"
#define STATE_PLAY  1
#define STATE_STOP  2
#define STATE_PAUSE 3
#define STATE_RESETED 4


@implementation LABTIMING
@synthesize state,timeEnd,timeStart,timerText,theTextAboutThisTimer;

-(int)howManyDaysHavePast:(NSDate*)lastDate today:(NSDate*)today {
	NSDate *startDate = lastDate;
	NSDate *endDate = today;
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	unsigned int unitFlags = NSDayCalendarUnit;
	NSDateComponents *components = [gregorian components:unitFlags
												fromDate:startDate
												  toDate:endDate options:0];
	int secs = [components second];
	return secs;
}


-(void)initWithState:(int)number withImageView:(UIImageView*)img
{
	state = STATE_RESETED;
	timerNumber = number;
	stateImageView = img;
	img.image = [UIImage imageNamed:@"blank.png"];
}
-(void)setPlay
{
	stateImageView.image = [UIImage imageNamed:@"playImage.png"];
	state = STATE_PLAY;
}
-(void)setPause
{
	stateImageView.image = [UIImage imageNamed:@"pauseImage.png"];
	state = STATE_PAUSE;
	
}
-(void)setStop
{
	stateImageView.image = [UIImage imageNamed:@"stopImage.png"];
	state = STATE_STOP;
}
-(void)setRing
{
	stateImageView.image = [UIImage imageNamed:@"bellImage.png"];
	//state = STATE_STOP;
}
-(void)setReset
{
	stateImageView.image = [UIImage imageNamed:@"blank.png"];
	state = STATE_RESETED;
}
-(NSString*)getCurrentTimeRemainingString
{
	if(state == STATE_RESETED)
	{
		return @"00:00:00";
	}
	if(state == STATE_PAUSE)
	{
		return timerText;
	}
	if(state == STATE_STOP)
	{
		return timerText;
	}
	
	return [self getTime];
	
}
-(NSString*)getTime
{
	BOOL isOver = NO;
	NSTimeInterval inter = [timeEnd timeIntervalSinceDate: [NSDate date]];
	if(inter < 0)
	{
		inter = [[NSDate date] timeIntervalSinceDate: timeEnd];
		isOver = YES;
	}
	int interval = inter;
	
	NSString  *sc = [NSString stringWithFormat:@"%d",interval % ( 60 )];
	if([sc length] == 1) sc = [NSString stringWithFormat:@"0%d",interval % ( 60 )];
	interval = interval / 60;
	
	NSString  *mn = [NSString stringWithFormat:@"%d",interval % ( 60 )];
	if([mn length] == 1) mn = [NSString stringWithFormat:@"0%d",interval % ( 60 )];
	interval = interval / 60;
	
	NSString  *hr = [NSString stringWithFormat:@"%d",interval];
	if([hr length] == 1) hr = [NSString stringWithFormat:@"0%d",interval % ( 60 )];
	
	if(isOver)
	{
		return [NSString stringWithFormat:@"-%@:%@:%@",hr,mn,sc];
	}
	
	return [NSString stringWithFormat:@"%@:%@:%@",hr,mn,sc];
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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


@end
