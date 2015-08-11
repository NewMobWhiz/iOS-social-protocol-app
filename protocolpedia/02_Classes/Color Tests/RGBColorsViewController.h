//
//  RGBColorsViewController.h
//  RGBColors
//
//   3/19/10.
//  Copyright MandellMobileApps 2010. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface RGBColorsViewController : UIViewController {
    UIView *viewHeader;
	NSString *whichItem;
	IBOutlet UISlider *redSlider;
	IBOutlet UISlider *greenSlider;	
	IBOutlet UISlider *blueSlider;

	IBOutlet UIView *colorView;
	
	IBOutlet UILabel *redLabel;
	IBOutlet UILabel *greenLabel;
	IBOutlet UILabel *blueLabel;

	IBOutlet UILabel *red1;
	IBOutlet UILabel *green1;
	IBOutlet UILabel *blue1;
	
}

@property(nonatomic, retain) NSString *whichItem;
@property(nonatomic, retain) IBOutlet UISlider *redSlider;
@property(nonatomic, retain) IBOutlet UISlider *greenSlider;	
@property(nonatomic, retain) IBOutlet UISlider *blueSlider;

@property(nonatomic, retain) IBOutlet UIView *colorView;
@property(nonatomic, retain) IBOutlet UILabel *redLabel;
@property(nonatomic, retain) IBOutlet UILabel *greenLabel;
@property(nonatomic, retain) IBOutlet UILabel *blueLabel;

@property(nonatomic, retain) IBOutlet UILabel *red1;
@property(nonatomic, retain) IBOutlet UILabel *green1;
@property(nonatomic, retain) IBOutlet UILabel *blue1;

-(IBAction)valueChanged:(id)sender;
-(void) setDefaultColor:(id)sender;

@end

