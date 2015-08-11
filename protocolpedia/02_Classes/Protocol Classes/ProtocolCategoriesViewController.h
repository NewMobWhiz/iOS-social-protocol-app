//
//  ProtocolCategoriesViewController.h
//  ProtocolPedia
//
//   7/7/10.


#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "PPAppDelegate.h"

@interface ProtocolCategoriesViewController : BaseTableViewController {
	int selectedIndex;
    UIView *viewHeader;
    
@private
    RevealBlock _revealBlock;
}
-(void)closeSubView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withRevealBlock:(RevealBlock)revealBlock;
-(void) loadFavorites:(id)sender;
-(void) manuallyReloadData:(id)sender;

@end
