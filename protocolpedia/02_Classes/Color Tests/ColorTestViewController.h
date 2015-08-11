//
//  ColorTestViewController.h
//  ProtocolPedia
//
//   8/15/10.


#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "PPAppDelegate.h"

@interface ColorTestViewController : BaseTableViewController {
    UIView *viewHeader;
@private
    RevealBlock _revealBlock;
}
-(void)closeSubView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withRevealBlock:(RevealBlock)revealBlock;

@end
