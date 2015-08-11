//
//  PPSearchTypeViewController.h
//  ProtocolPedia
//
//  25/06/14.


#import "PPAbstractViewController.h"

@interface PPSearchTypeViewController : PPAbstractViewController

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;

@property(nonatomic,retain) NSString *searchType;

@end
