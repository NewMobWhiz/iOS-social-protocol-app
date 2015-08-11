//
//  PPLeftMenuViewController.h
//  ProtocolPedia
//
//  20/02/14.


#import <UIKit/UIKit.h>

@interface PPLeftMenuViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;

@end
