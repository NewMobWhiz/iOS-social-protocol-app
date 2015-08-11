//
//  VideoCategoriesViewController.h
//  ProtocolPedia
//
//   7/16/10.


#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PPAppDelegate.h"

@interface VideoCategoriesViewController : BaseViewController {
    UIView *viewHeader;
	NSMutableArray *videoCounts;
@private
    RevealBlock _revealBlock;
}

@property(nonatomic,retain) NSMutableArray *videoCounts; 

-(void)closeSubView;
-(void) manuallyReloadData ;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withRevealBlock:(RevealBlock)revealBlock;
@end
