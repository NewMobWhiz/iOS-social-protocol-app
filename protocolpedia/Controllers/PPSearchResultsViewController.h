//
//  PPSearchResultsViewController.h
//  ProtocolPedia
//
//  25/06/14.


#import "PPAbstractViewController.h"

@interface PPSearchResultsViewController : PPAbstractViewController


@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;

@property(nonatomic,retain) NSArray *protocolSearchResults;
@property(nonatomic,retain) NSArray *topicsSearchResults;
@property(nonatomic,retain) NSArray *videosSearchResults;
@property(nonatomic,retain) NSMutableArray *myFavorites;
@property(nonatomic,retain) NSString *favoriteProtocol;



-(void)confirmChange:(NSNotification*)notification;
-(void) changeFavorite:(UIButton*)sender;

@end
