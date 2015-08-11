//
//  PPDiscussionsViewController.h
//  ProtocolPedia
//
//  26/03/14.


#import "PPAbstractViewController.h"

@interface PPDiscussionsViewController : PPAbstractViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataSource;

@property(nonatomic,retain) GetForumDiscussions *getForumDiscussions;

-(void) getForumDiscussionsMethod:(id)sender;
-(void) getForumDiscussionsComplete:(NSNotification *)notification;

@end
