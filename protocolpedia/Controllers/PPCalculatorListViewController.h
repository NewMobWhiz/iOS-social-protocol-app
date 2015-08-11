//
//  PPCalculatorListViewController.h
//  ProtocolPedia
//
//  27/02/14.


#import "PPAbstractViewController.h"

@interface PPCalculatorListViewController : PPAbstractViewController

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;

@end
