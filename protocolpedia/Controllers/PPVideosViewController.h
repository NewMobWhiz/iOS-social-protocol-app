//
//  PPVideosViewController.h
//  ProtocolPedia
//
//  26/03/14.


#import "PPAbstractViewController.h"

@interface PPVideosViewController : PPAbstractViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataSource;

@property(nonatomic,retain) NSString *selectedCategory;

@end
