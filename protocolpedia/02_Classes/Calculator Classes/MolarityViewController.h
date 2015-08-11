//
//  MolarityViewController.h
//  ProtocolPedia
//
//   9/4/10.


#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

@interface MolarityViewController :BaseTableViewController <UITextFieldDelegate>{

	NSString *result;
	NSMutableDictionary *calculatorData;
	UIView *viewHeader;
}

@property(nonatomic,retain) NSString *result;
@property(nonatomic,retain) NSMutableDictionary *calculatorData;

-(void) calculateValues;
-(void) updateSelectionFor:(NSString*)key with:(NSString*)value ;

@end
