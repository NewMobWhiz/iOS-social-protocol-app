//
//  CalculatorListViewController.h
//  ProtocolPedia
//
//   7/8/10.


#import <UIKit/UIKit.h>
#import "PPAppDelegate.h"
#import "BaseViewController.h"


@interface CalculatorListViewController : BaseViewController {
    UIView *viewHeader;
@private
    RevealBlock _revealBlock;
}
-(void)closeSubView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withRevealBlock:(RevealBlock)revealBlock;

@end
