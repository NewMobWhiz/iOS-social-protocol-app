//
//  PPTopicsViewController.h
//  ProtocolPedia
//
//  26/03/14.


#import "PPAbstractViewController.h"

@interface PPTopicsViewController : PPAbstractViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@property(nonatomic,retain) NSString *categoryId;


-(void) addTopic:(id)sender;
-(void) reloadTable:(NSNotification*)notification;

@end
