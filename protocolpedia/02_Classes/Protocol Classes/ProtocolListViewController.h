//
//  ProtocolListViewController.h
//  ProtocolPedia
//
//   7/9/10.


#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

@interface ProtocolListViewController : BaseTableViewController {

	NSString *selectedCategoryId;
	NSMutableArray *myFavorites;
	NSString *favoriteProtocol;
    UIView *viewHeader;
}

@property(nonatomic,retain) NSString *selectedCategoryId;
@property(nonatomic,retain) NSMutableArray *myFavorites;
@property(nonatomic,retain) NSString *favoriteProtocol;

-(void) changeFavorite:(UIButton*)sender;
-(void)confirmChange:(NSNotification*)notification;


@end
