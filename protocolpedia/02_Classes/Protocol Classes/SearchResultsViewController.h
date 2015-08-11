//
//  SearchResultsViewController.h
//  ProtocolPedia
//
//   8/17/10.


#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

@interface SearchResultsViewController : BaseTableViewController {

	NSArray *protocolSearchResults;
	NSArray *topicsSearchResults;
	NSArray *videosSearchResults;
	NSMutableArray *myFavorites;
	NSString *favoriteProtocol;
    UIView *viewHeader;
}

@property(nonatomic,retain) NSArray *protocolSearchResults;
@property(nonatomic,retain) NSArray *topicsSearchResults;
@property(nonatomic,retain) NSArray *videosSearchResults;
@property(nonatomic,retain) NSMutableArray *myFavorites;
@property(nonatomic,retain) NSString *favoriteProtocol;



-(void)confirmChange:(NSNotification*)notification;
-(void) changeFavorite:(UIButton*)sender;

@end
