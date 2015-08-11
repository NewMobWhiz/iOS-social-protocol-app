//
//  FavoriteListViewController.h
//  ProtocolPedia
//
//   8/17/10.


#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "PPAppDelegate.h"

@interface FavoriteListViewController : BaseTableViewController {

	NSString  *thisFavorite;
	int currentTag;
    
    NSNumber *_typeView;
    UIView *viewHeader;
    
@private
    RevealBlock _revealBlock;
}

@property(nonatomic, retain) NSString  *thisFavorite;
@property(nonatomic, retain) UIView *viewHeader;
@property(nonatomic, retain) NSNumber *typeView;
@property(nonatomic, assign) int currentTag;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withRevealBlock:(RevealBlock)revealBlock;
-(void) changeFavorite:(UIButton*)sender;
-(void)confirmChange:(NSNotification*)notification;
-(void)closeSubView;
@end
