//
//  RGBColorsViewController.m
//  RGBColors
//
//   3/19/10.
//  Copyright MandellMobileApps 2010. All rights reserved.
//

#import "RGBColorsViewController.h"
#import "PPAppDelegate.h"

@implementation RGBColorsViewController

@synthesize whichItem;
@synthesize redSlider;
@synthesize greenSlider;	
@synthesize blueSlider;

@synthesize colorView;
@synthesize redLabel;
@synthesize greenLabel;
@synthesize blueLabel;

@synthesize red1;
@synthesize green1;
@synthesize blue1;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/
-(IBAction)valueChanged:(id)sender {



	self.redLabel.text = [NSString stringWithFormat:@"%2.0f",(redSlider.value*255)];
	self.greenLabel.text = [NSString stringWithFormat:@"%2.0f",(greenSlider.value*255)];
	self.blueLabel.text = [NSString stringWithFormat:@"%2.0f",(blueSlider.value*255)];

	
	self.red1.text = [NSString stringWithFormat:@"%2.2f",(redSlider.value)];
	self.green1.text = [NSString stringWithFormat:@"%2.2f",(greenSlider.value)];
	self.blue1.text = [NSString stringWithFormat:@"%2.2f",(blueSlider.value)];

	colorView.backgroundColor = [UIColor colorWithRed:self.redSlider.value green:self.greenSlider.value blue:self.blueSlider.value alpha:1.0];
	
	PPAppDelegate *appDelegate = (PPAppDelegate*)[[UIApplication sharedApplication]delegate];
	[appDelegate.settings setObject:@"Yes" forKey:@"ColorChanged"];
    
    if ([self.whichItem isEqualToString:@"NavBar Color"]) {
        viewHeader.backgroundColor = [UIColor colorWithRed:self.redSlider.value green:self.greenSlider.value blue:self.blueSlider.value alpha:1.0];
    }
}

-(void) setDefaultColor:(id)sender {
	PPAppDelegate *appDelegate = (PPAppDelegate*)[[UIApplication sharedApplication]delegate];
	[appDelegate.settings setObject:@"Yes" forKey:@"ColorChanged"];
	if ([self.whichItem isEqualToString:@"NavBar Color"]) {
		self.redLabel.text = @"0";
		self.greenLabel.text = @"0";
		self.blueLabel.text = @"0";
		self.red1.text = @"0";
		self.green1.text = @"0";
		self.blue1.text = @"0";
		colorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
		self.redSlider.value = 	0;
		self.greenSlider.value = 0;
		self.blueSlider.value = 0;
        
        UIColor *myTintColor = [UIColor colorWithRed:([[appDelegate.settings objectForKey:@"TintRed"] floatValue]/255.0) green:([[appDelegate.settings objectForKey:@"TintGreen"] floatValue]/255.0) blue:([[appDelegate.settings objectForKey:@"TintBlue"] floatValue]/255.0) alpha:1.0];
        viewHeader.backgroundColor = myTintColor;
        
	} else if ([self.whichItem isEqualToString:@"View Color"]) {
		self.redLabel.text = @"38";
		self.greenLabel.text = @"71";
		self.blueLabel.text = @"120";
		self.red1.text = @"0.15";
		self.green1.text = @"0.29";
		self.blue1.text = @"0.47";
		colorView.backgroundColor = [UIColor colorWithRed:0.15 green:0.29 blue:0.47 alpha:1.0];
		self.redSlider.value = 	0.15;
		self.greenSlider.value = 0.29;
		self.blueSlider.value = 0.47;
	}
    
}
	 
	 
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

	PPAppDelegate *appDelegate = (PPAppDelegate*)[[UIApplication sharedApplication]delegate];
	
	//NSLog(@"%@, %@, %@",self.redLabel.text,self.greenLabel.text,self.blueLabel.text);

	if ([self.whichItem isEqualToString:@"NavBar Color"]) {
		[appDelegate.settings setObject:self.redLabel.text forKey:@"TintRed"];
		[appDelegate.settings setObject:self.greenLabel.text forKey:@"TintGreen"];
		[appDelegate.settings setObject:self.blueLabel.text forKey:@"TintBlue"];
	} else if ([self.whichItem isEqualToString:@"View Color"]) {
		[appDelegate.settings setObject:self.redLabel.text forKey:@"Red"];
		[appDelegate.settings setObject:self.greenLabel.text forKey:@"Green"];
		[appDelegate.settings setObject:self.blueLabel.text forKey:@"Blue"];	
	} else if ([self.whichItem isEqualToString:@"Text"]) {
		[appDelegate.settings setObject:self.redLabel.text forKey:@"TextRed"];
		[appDelegate.settings setObject:self.greenLabel.text forKey:@"TextGreen"];
		[appDelegate.settings setObject:self.blueLabel.text forKey:@"TextBlue"];	
	}


}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	UIBarButtonItem *defaultColors = [[UIBarButtonItem alloc] initWithTitle:@"Default Color" style:UIBarButtonItemStyleBordered target:self action:@selector(setDefaultColor:)]; 
	self.navigationItem.rightBarButtonItem = defaultColors;
	
	PPAppDelegate *appDelegate = (PPAppDelegate*)[[UIApplication sharedApplication]delegate];

	if ([self.whichItem isEqualToString:@"NavBar Color"]) {
		self.redLabel.text = [appDelegate.settings objectForKey:@"TintRed"];
		self.greenLabel.text = [appDelegate.settings objectForKey:@"TintGreen"];
		self.blueLabel.text = [appDelegate.settings objectForKey:@"TintBlue"];
		self.redSlider.value = ([[appDelegate.settings objectForKey:@"TintRed"] floatValue] / 255);
		self.greenSlider.value = ([[appDelegate.settings objectForKey:@"TintGreen"] floatValue] / 255);
		self.blueSlider.value = ([[appDelegate.settings objectForKey:@"TintBlue"] floatValue] / 255);
		
	} else if ([self.whichItem isEqualToString:@"View Color"]) {
		self.redLabel.text = [appDelegate.settings objectForKey:@"Red"];
		self.greenLabel.text = [appDelegate.settings objectForKey:@"Green"];
		self.blueLabel.text = [appDelegate.settings objectForKey:@"Blue"];
		self.redSlider.value = ([[appDelegate.settings objectForKey:@"Red"] floatValue] / 255);
		self.greenSlider.value = ([[appDelegate.settings objectForKey:@"Green"] floatValue] / 255);
		self.blueSlider.value = ([[appDelegate.settings objectForKey:@"Blue"] floatValue] / 255);
	} else if ([self.whichItem isEqualToString:@"Text"]) {	
		self.redLabel.text = [appDelegate.settings objectForKey:@"TextRed"];
		self.greenLabel.text = [appDelegate.settings objectForKey:@"TextGreen"];
		self.blueLabel.text = [appDelegate.settings objectForKey:@"TextBlue"];
		self.redSlider.value = ([[appDelegate.settings objectForKey:@"TextRed"] floatValue] / 255);
		self.greenSlider.value = ([[appDelegate.settings objectForKey:@"TextGreen"] floatValue] / 255);
		self.blueSlider.value = ([[appDelegate.settings objectForKey:@"TextBlue"] floatValue] / 255);	
	}

	colorView.backgroundColor = [UIColor colorWithRed:self.redSlider.value green:self.greenSlider.value blue:self.blueSlider.value alpha:1.0];
    
    float wDevice = 320;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        wDevice = 768;
    }
    else{
        wDevice = 320;
    }
	
    viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wDevice, 50)];
    viewHeader.backgroundColor = [UIColor colorWithRed:46.0/255 green:133.0/255 blue:189.0/255 alpha:1.0];
    [self.view addSubview:viewHeader];
    
    UILabel *lb1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, wDevice, 50)];
    lb1.textColor = [UIColor whiteColor];
    lb1.backgroundColor = [UIColor clearColor];
    lb1.font = [UIFont fontWithName:@"Arial" size:18];
    lb1.text = whichItem;
    lb1.textAlignment = UITextAlignmentCenter;
    [viewHeader addSubview:lb1];
    
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 46, 40)];
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        [btnBack setImage:[UIImage imageNamed:@"imv_back.png"] forState:UIControlStateNormal];
//    }
//    else{
        [btnBack setImage:[UIImage imageNamed:@"icn_menu_main.png"] forState:UIControlStateNormal];
//    }
    [btnBack addTarget:self action:@selector(revealSidebar) forControlEvents:UIControlEventTouchUpInside];
    [viewHeader addSubview:btnBack];
    
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        viewHeader.frame = CGRectMake(0, 0, 448, 50);
//        lb1.frame = CGRectMake(0, 0, 448, 50);
//    }
}

-(void)revealSidebar{
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        [UIView animateWithDuration:0.3 animations:^{
//            self.view.frame = CGRectMake(448, 0, 448, 1004);
//        } completion:^(BOOL finished) {
//            [self.view removeFromSuperview];
//            [self release];
//        }];
//        return;
//    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    PPAppDelegate *appDelegate = (PPAppDelegate*)[[UIApplication sharedApplication]delegate];
    
//    UIColor *myColor = [UIColor colorWithRed:([[appDelegate.settings objectForKey:@"Red"] floatValue]/255.0) green:([[appDelegate.settings objectForKey:@"Green"] floatValue]/255.0) blue:([[appDelegate.settings objectForKey:@"Blue"] floatValue]/255.0) alpha:1.0];
    UIColor *myTintColor = [UIColor colorWithRed:([[appDelegate.settings objectForKey:@"TintRed"] floatValue]/255.0) green:([[appDelegate.settings objectForKey:@"TintGreen"] floatValue]/255.0) blue:([[appDelegate.settings objectForKey:@"TintBlue"] floatValue]/255.0) alpha:1.0];
    viewHeader.backgroundColor = myTintColor;
//    self.view.backgroundColor = myColor;
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
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}




@end
