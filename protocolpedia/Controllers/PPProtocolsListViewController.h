//
//  PPProtocolsListViewController.h
//  ProtocolPedia
//
//  21/02/14.


#import "PPAbstractViewController.h"

@interface PPProtocolsListViewController : PPAbstractViewController

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSString *categoryID;

@property(nonatomic,retain) NSMutableArray *myFavorites;

@property BOOL isPushed;

- (IBAction)favoriteButtonPressed:(id)sender;

@end
