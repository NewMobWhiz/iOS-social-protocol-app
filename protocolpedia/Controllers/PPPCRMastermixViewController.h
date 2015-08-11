//
//  PPPCRMastermixViewController.h
//  ProtocolPedia
//
//  05/03/14.


#import "PPAbstractViewController.h"

@interface PPPCRMastermixViewController : PPAbstractViewController <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;

@property(nonatomic,retain) NSMutableArray *myValues;

-(void)calculateValues;
-(void) loadInfo:(id)sender;

@end
