

#import <UIKit/UIKit.h>
#import "PPAppDelegate.h"

@interface labTimerCalculator : UIViewController<UITextFieldDelegate>{
	IBOutlet UISegmentedControl *theHourMinSecSegment;
	IBOutlet UISegmentedControl *theNumberSegment;
	IBOutlet UIImageView *upper1ImageView;
	IBOutlet UIImageView *upper2ImageView;
	IBOutlet UIImageView *upper3ImageView;
	IBOutlet UIImageView *upper4ImageView;
	
	IBOutlet UILabel *theTimerLable;
	IBOutlet UITextField *theTextField;
	IBOutlet UILabel *theLableField;
	IBOutlet UIButton *theClearButton;
	IBOutlet UIButton *theStartButton;
	NSMutableArray *theTimerArray;
	
	NSTimer *theTimer;
    UIView *viewHeader;
    
}

-(void)playSound;

@property (nonatomic,retain) NSMutableArray *theTimerArray;

-(IBAction)bottomSegmentButtonTouchEnd:(id)sender;
-(IBAction)topSegmentButtonClicked:(id)sender;
-(IBAction)bottomSegmentButtonClicked:(id)sender;
-(IBAction)clearButtonClicked:(id)sender;
-(IBAction)startButtonClicked:(id)sender;


@end
