//
//  PPProtocolCategoriesViewController.h
//  ProtocolPedia
//
//  20/02/14.


#import "PPAbstractViewController.h"

@interface PPProtocolCategoriesViewController : PPAbstractViewController

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;

@end
