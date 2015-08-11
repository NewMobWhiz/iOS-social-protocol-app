//
//  PPSearchProtocolsViewController.h
//  ProtocolPedia
//
//  25/06/14.


#import "PPAbstractViewController.h"

@interface PPSearchProtocolsViewController : PPAbstractViewController

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;

@property(nonatomic,retain) IBOutlet UITextField *searchFor;
@property(nonatomic,retain) NSString *searchForString;
@property(nonatomic,retain) NSMutableArray *selectedProtocolCategories;
@property(nonatomic,retain) NSMutableArray *selectedTopicsCategories;
@property(nonatomic,retain) NSMutableArray *selectedVideosCategories;
@property(nonatomic,retain) NSArray *protocolSearchResults;
@property(nonatomic,retain) NSArray *topicsSearchResults;
@property(nonatomic,retain) NSArray *videosSearchResults;

@property(nonatomic,assign) int searchOption;

-(void) getSelectedCategories;
-(void) getSearchResults;
-(void) anyWords;
-(void) allWords;
-(void) exactPhrase;

@end
