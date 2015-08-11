//
//  BaseTableViewController.h
//  ProtocolPedia
//
//   7/12/10.


#import <UIKit/UIKit.h>
#import "PPAppDelegate.h"


@interface BaseTableViewController : UIViewController {
	PPAppDelegate *appDelegate;
	NSMutableArray *menuItems;
	IBOutlet UITableView *tableViewOutlet;
	UIView	*navbarView;
	NSString *navbarTitle;
}

@property (nonatomic,retain) NSMutableArray *menuItems;
@property (nonatomic,retain) PPAppDelegate *appDelegate;
@property (nonatomic,retain) IBOutlet UITableView *tableViewOutlet;
@property (nonatomic, retain) UIView	*navbarView;
@property (nonatomic, retain) NSString *navbarTitle;

-(void) statusMessage:(NSNotification*)notification;

@end
