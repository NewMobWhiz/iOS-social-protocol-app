//
//  PPResuspensionViewController.h
//  ProtocolPedia
//
//  05/03/14.


#import "PPAbstractViewController.h"

@interface PPResuspensionViewController : PPAbstractViewController <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property(nonatomic,retain) NSString *result;
@property(nonatomic,retain) NSMutableDictionary *calculatorData;

-(void) calculateValues;
-(void) updateSelectionFor:(NSString*)key with:(NSString*)value ;

@end
