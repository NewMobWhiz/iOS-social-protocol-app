
#import "labTimerCalculator.h"
#import "LABTIMING.h"
#import <AudioToolbox/AudioToolbox.h>
#define STATE_PLAY  1
#define STATE_STOP  2
#define STATE_PAUSE 3
#define STATE_RESETED 4
@implementation labTimerCalculator

@synthesize theTimerArray;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

-(NSString*)getDate:(NSDate*) dateData
{
	NSCalendar *cal = [NSCalendar currentCalendar];
	//NSDateComponents *comp1 = [cal components:NSYearCalendarUnit fromDate:dateData];
	NSDateComponents *comp2 = [cal components:NSMonthCalendarUnit fromDate:dateData];
	NSDateComponents *comp3 = [cal components:NSDayCalendarUnit fromDate:dateData];
	NSDateComponents *comp4 = [cal components:NSMinuteCalendarUnit fromDate:dateData];
	NSDateComponents *comp5 = [cal components:NSHourCalendarUnit fromDate:dateData];
	NSDateComponents *comp6 = [cal components:NSSecondCalendarUnit fromDate:dateData];
	
	//NSString *yer = [NSString stringWithFormat:@"%d",[comp1 year]]; 
	
	NSString *mon = [NSString stringWithFormat:@"%d",[comp2 month]]; 
	if([mon length] == 1)  mon = [NSString stringWithFormat:@"0%d",[comp2 month]];
	NSString *dayy = [NSString stringWithFormat:@"%d",[comp3 day]];
	if([dayy length] == 1) dayy = [NSString stringWithFormat:@"0%d",[comp3 day]];
	
	NSString *min = [NSString stringWithFormat:@"%d",[comp4 minute]]; 
	if([min length] == 1) min = [NSString stringWithFormat:@"0%d",[comp4 minute]];
	NSString *hor = [NSString stringWithFormat:@"%d",[comp5 hour]]; 
	if([hor length] == 1) hor = [NSString stringWithFormat:@"0%d",[comp5 hour]];
	
	NSString *sec = [NSString stringWithFormat:@"%d",[comp6 second]]; 
	if([sec length] == 1) sec = [NSString stringWithFormat:@"0%d",[comp6 second]];

	NSString *ampm = @"AM";
	int hhh = [hor intValue];
	if(hhh > 12)
	{
		hor = [NSString stringWithFormat:@"%d",[comp5 hour]-12]; 
		if([hor length] == 1) hor = [NSString stringWithFormat:@"0%d",[comp5 hour]-12];

		ampm = @"PM";
	}else if(hhh == 12)
	{
		ampm = @"PM";
	}
	
	
	return [NSString stringWithFormat:@"Finish: %@:%@:%@ %@",hor,min,sec,ampm];
}



-(IBAction)topSegmentButtonClicked:(id)sender
{
	[theTimerLable setTextColor:[UIColor blackColor]];
	int ind = theNumberSegment.selectedSegmentIndex;
	LABTIMING *theTim = (LABTIMING*)[theTimerArray objectAtIndex:ind];
	
	//theTim.theTextAboutThisTimer = [textField text];
	theTextField.text = theTim.theTextAboutThisTimer;
	
	if(theTim.state == STATE_RESETED)
	{
		[theTimerLable setTextColor:[UIColor blackColor]];
		theTimerLable.text = @"00:00:00";
		
		[theStartButton setTitle:@"START" forState:UIControlStateNormal];
		[theStartButton setTitle:@"START" forState:UIControlStateSelected];
		[theHourMinSecSegment setEnabled:YES];
		
		theLableField.text = @"";
	}
	if(theTim.state == STATE_PLAY)
	{
		[theStartButton setTitle:@"STOP" forState:UIControlStateNormal];
		[theStartButton setTitle:@"STOP" forState:UIControlStateSelected];
		[theHourMinSecSegment setEnabled:NO];
	
		
		theLableField.text = [self getDate:theTim.timeStart];
		
		
		
	}
	if(theTim.state == STATE_PAUSE)
	{
		[theStartButton setTitle:@"START" forState:UIControlStateNormal];
		[theStartButton setTitle:@"START" forState:UIControlStateSelected];
		[theHourMinSecSegment setEnabled:NO];
		
		theLableField.text = @"";
	}
	if(theTim.state == STATE_STOP)
	{
		[theStartButton setTitle:@"RESET" forState:UIControlStateNormal];
		[theStartButton setTitle:@"RESET" forState:UIControlStateSelected];
		[theHourMinSecSegment setEnabled:NO];
		
		theLableField.text = @"";
		[theTimerLable setTextColor:[UIColor redColor]];
	}
	
	
	NSString *str = [theTim getCurrentTimeRemainingString];
	if([[str substringToIndex:1] isEqualToString:@"-"])
	{
		str = [str substringFromIndex:1];
		
	}else {
		
	}
	
	theTimerLable.text = str;
}
-(IBAction)bottomSegmentButtonTouchEnd:(id)sender
{
	
}
-(IBAction)bottomSegmentButtonClicked:(id)sender
{
	
	//NSLog(@"selected index:   %d",theHourMinSecSegment.selectedSegmentIndex);
	NSArray *theArr = [theTimerLable.text componentsSeparatedByString:@":"];
	NSString *hour = [theArr objectAtIndex:0];
	NSString *min  = [theArr objectAtIndex:1];
	NSString *sec  = [theArr objectAtIndex:2];
	
	if(theHourMinSecSegment.selectedSegmentIndex == 0)
	{
		int hr = [hour intValue]+1;
		if(hr == 24) hr = 0;
		hour = [NSString stringWithFormat:@"%d",hr];
		if([hour length] == 1) hour = [NSString stringWithFormat:@"0%d",hr];
	}else if(theHourMinSecSegment.selectedSegmentIndex == 1)
	{
		int hr = [min intValue]+1;
		if(hr == 60) hr = 0;
		min = [NSString stringWithFormat:@"%d",hr];
		if([min length] == 1) min = [NSString stringWithFormat:@"0%d",hr];
	}else if(theHourMinSecSegment.selectedSegmentIndex == 2){
		
			int hr = [sec intValue]+1;
		if(hr == 60) hr = 0;
			sec = [NSString stringWithFormat:@"%d",hr];
			if([sec length] == 1) sec = [NSString stringWithFormat:@"0%d",hr];
		
	}
	
	theTimerLable.text = [NSString stringWithFormat:@"%@:%@:%@",hour,min,sec];
	
	[theHourMinSecSegment setSelectedSegmentIndex:-1];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	int ind = theNumberSegment.selectedSegmentIndex;
	LABTIMING *theTim = (LABTIMING*)[theTimerArray objectAtIndex:ind];
	
	theTim.theTextAboutThisTimer = [textField text];
	
	return YES;
}
-(IBAction)clearButtonClicked:(id)sender
{
	int ind = theNumberSegment.selectedSegmentIndex;
	LABTIMING *theTim = (LABTIMING*)[theTimerArray objectAtIndex:ind];

	theTim.state = STATE_RESETED;
	theTimerLable.text = @"00:00:00";
	[theStartButton setTitle:@"START" forState:UIControlStateNormal];
	[theStartButton setTitle:@"START" forState:UIControlStateSelected];
	[theTim setReset];
	[theTimerLable setTextColor:[UIColor blackColor]];
	theLableField.text = @"";
	theTim.theTextAboutThisTimer = @"";
	theTextField.text = @"";
	[theHourMinSecSegment setEnabled:YES];
	
}
-(IBAction)startButtonClicked:(id)sender
{
	int ind = theNumberSegment.selectedSegmentIndex;
	LABTIMING *theTim = (LABTIMING*)[theTimerArray objectAtIndex:ind];
	if(theTim.state == STATE_RESETED)
	{
		theTim.timeStart = [NSDate date];

		NSArray *theArr = [theTimerLable.text componentsSeparatedByString:@":"];
		NSTimeInterval interv = [[theArr objectAtIndex:0]intValue] * 3600 +
			[[theArr objectAtIndex:1]intValue] * 60 +
			[[theArr objectAtIndex:2]intValue];
		
		theTim.timeEnd = [theTim.timeStart addTimeInterval:interv];
		
		theTim.state = STATE_PLAY;
		[theTim setPlay];
		
		[theStartButton setTitle:@"STOP" forState:UIControlStateNormal];
		[theStartButton setTitle:@"STOP" forState:UIControlStateSelected];
		[theHourMinSecSegment setEnabled:NO];
		theLableField.text = [self getDate:theTim.timeStart];
		
	}else if(theTim.state == STATE_PLAY)
	{
		theTim.timerText = theTimerLable.text;
		
		NSString *str = [theTim getCurrentTimeRemainingString];
		if([[str substringToIndex:1] isEqualToString:@"-"])
		{
			theTim.state = STATE_STOP;
			[theTim setStop];
			[theStartButton setTitle:@"RESET" forState:UIControlStateNormal];
			[theStartButton setTitle:@"RESET" forState:UIControlStateSelected];
			[theHourMinSecSegment setEnabled:NO];
		}else {
			theTim.state = STATE_PAUSE;
			[theTim setPause];
			[theStartButton setTitle:@"START" forState:UIControlStateNormal];
			[theStartButton setTitle:@"START" forState:UIControlStateSelected];
			[theHourMinSecSegment setEnabled:NO];
		}
	}else if(theTim.state == STATE_STOP)
	{
		theTim.state = STATE_RESETED;
		theTimerLable.text = @"00:00:00";
		[theStartButton setTitle:@"START" forState:UIControlStateNormal];
		[theStartButton setTitle:@"START" forState:UIControlStateSelected];
		[theTim setReset];
		[theHourMinSecSegment setEnabled:YES];
		
	}else if(theTim.state == STATE_PAUSE)
	{
		theTim.timeStart = [NSDate date];
		NSArray *theArr = [theTimerLable.text componentsSeparatedByString:@":"];
		NSTimeInterval interv = [[theArr objectAtIndex:0]intValue] * 3600 +
		[[theArr objectAtIndex:1]intValue] * 60 +
		[[theArr objectAtIndex:2]intValue];
		
		theTim.timeEnd = [theTim.timeStart addTimeInterval:interv];
		
		theTim.state = STATE_PLAY;
		[theTim setPlay];
		
		[theStartButton setTitle:@"STOP" forState:UIControlStateNormal];
		[theStartButton setTitle:@"STOP" forState:UIControlStateSelected];
		[theHourMinSecSegment setEnabled:NO];
		
		theLableField.text = [self getDate:theTim.timeStart];
	}

}
/*
-(void)viewWillAppear:(BOOL)animated{
    UIColor *myColor = [UIColor colorWithRed:([[self.appDelegate.settings objectForKey:@"Red"] floatValue]/255.0) green:([[self.appDelegate.settings objectForKey:@"Green"] floatValue]/255.0) blue:([[self.appDelegate.settings objectForKey:@"Blue"] floatValue]/255.0) alpha:1.0];
    UIColor *myTintColor = [UIColor colorWithRed:([[self.appDelegate.settings objectForKey:@"TintRed"] floatValue]/255.0) green:([[self.appDelegate.settings objectForKey:@"TintGreen"] floatValue]/255.0) blue:([[self.appDelegate.settings objectForKey:@"TintBlue"] floatValue]/255.0) alpha:1.0];
    self.navigationController.navigationBar.tintColor = myTintColor;
    viewHeader.backgroundColor = myTintColor;
    self.view.backgroundColor = myColor;
}
*/
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.title = @"Lab Timer";
	
    //[theHourMinSecSegment setEnabled:NO forSegmentAtIndex:<#(NSUInteger)segment#>
	[theHourMinSecSegment setSelectedSegmentIndex:-1];
	
	theTimerArray = [[NSMutableArray alloc]initWithCapacity:4];
	
	LABTIMING *theTim = [[LABTIMING alloc]init];
	[theTim initWithState:0 withImageView:upper1ImageView];
	[theTimerArray addObject:theTim];
	
	theTim = [[LABTIMING alloc]init];
	[theTim initWithState:1 withImageView:upper2ImageView];
	[theTimerArray addObject:theTim];
	
	theTim = [[LABTIMING alloc]init];
	[theTim initWithState:2 withImageView:upper3ImageView];
	[theTimerArray addObject:theTim];
	
	theTim = [[LABTIMING alloc]init];
	[theTim initWithState:3 withImageView:upper4ImageView];
	[theTimerArray addObject:theTim];
	
	theTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:self
											   repeats:YES];
    
    UIImage *backImage = [UIImage imageNamed:@"btn_back.png"];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, backImage.size.width, backImage.size.height)];
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onBackButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
}

- (IBAction)onBackButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)timerAction
{
	int ind = theNumberSegment.selectedSegmentIndex;
	LABTIMING *theTim = (LABTIMING*)[theTimerArray objectAtIndex:ind];
	if(theTim.state == STATE_RESETED)
	{
		
	}else if(theTim.state == STATE_STOP)
	{
		[theTimerLable setTextColor:[UIColor redColor]];
	}
	else
	{
		NSString *str = [theTim getCurrentTimeRemainingString];
		if([[str substringToIndex:1] isEqualToString:@"-"])
		{
			[self playSound];
			str = [str substringFromIndex:1];
			[theTimerLable setTextColor:[UIColor redColor]];
		}else {
			[theTimerLable setTextColor:[UIColor blackColor]];
		}

		theTimerLable.text = str;
	}
	
	for (int i=0; i < 4; i++) {
		LABTIMING *theTim = (LABTIMING*)[theTimerArray objectAtIndex:i];
		if(theTim.state == STATE_PLAY)
		{
			NSString *str = [theTim getCurrentTimeRemainingString];
			if([[str substringToIndex:1] isEqualToString:@"-"])
			{
				[theTim setRing];
			}
		}
		//NSString *str = [theTim getCurrentTimeRemainingString];
	}
	
}
-(void)playSound
{
	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate); 
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
