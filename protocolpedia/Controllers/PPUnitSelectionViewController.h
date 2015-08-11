//
//  PPUnitSelectionViewController.h
//  ProtocolPedia
//
//  05/03/14.


#import "PPAbstractViewController.h"

@interface PPUnitSelectionViewController : PPAbstractViewController

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@property(nonatomic,retain) NSString *currentSelection;
@property(nonatomic,retain) NSString *keyValue;


@end
