//
//  PPVideoCategorisViewController.h
//  ProtocolPedia
//
//  06/03/14.


#import "PPAbstractViewController.h"

@interface PPVideoCategorisViewController : PPAbstractViewController

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic,strong) NSMutableArray *videoCounts;

@end
