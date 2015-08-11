//
//  PPDillutionCalculatorViewController.h
//  ProtocolPedia
//
//  04/03/14.


#import "PPAbstractViewController.h"

@interface PPDilutionCalculatorViewController : PPAbstractViewController <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property(nonatomic,retain) NSString *result;
@property(nonatomic,retain) NSMutableDictionary *calculatorData;

-(void) calculateValues;
-(void) updateSelectionFor:(NSString*)key with:(NSString*)value ;


@end
