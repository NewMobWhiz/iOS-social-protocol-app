//
//  DilutionCalculatorViewController.h
//  ProtocolPedia
//
//   8/30/10.


#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"


@interface DilutionCalculatorViewController : BaseTableViewController <UITextFieldDelegate> {

	NSString *result;
	NSMutableDictionary *calculatorData;
	UIView *viewHeader;
}

@property(nonatomic,retain) NSString *result;
@property(nonatomic,retain) NSMutableDictionary *calculatorData;

-(void) calculateValues;
-(void) updateSelectionFor:(NSString*)key with:(NSString*)value ;

@end
