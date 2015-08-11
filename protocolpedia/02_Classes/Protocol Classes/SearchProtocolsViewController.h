//
//  SearchProtocolsViewController.h
//  ProtocolPedia
//
//   7/8/10.


#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PPAppDelegate.h"

#import "PPAbstractViewController.h"

@interface SearchProtocolsViewController : PPAbstractViewController   {

	IBOutlet UITextField *searchFor;
	NSString *searchForString;
	NSMutableArray *selectedProtocolCategories;
	NSMutableArray *selectedTopicsCategories;
	NSMutableArray *selectedVideosCategories;
	NSArray *protocolSearchResults;
	NSArray *topicsSearchResults;
	NSArray *videosSearchResults;
	
	int searchOption;
//	int protocolCategoryCount;
//	int topicsCategoryCount;
//	int videoCategoryCount;
    UIView *viewHeader;
@private
    RevealBlock _revealBlock;

}

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;

@property(nonatomic,retain) IBOutlet UITextField *searchFor;
@property(nonatomic,retain) NSString *searchForString;
@property(nonatomic,retain) NSMutableArray *selectedProtocolCategories;
@property(nonatomic,retain) NSMutableArray *selectedTopicsCategories;
@property(nonatomic,retain) NSMutableArray *selectedVideosCategories;
@property(nonatomic,retain) NSArray *protocolSearchResults;
@property(nonatomic,retain) NSArray *topicsSearchResults;
@property(nonatomic,retain) NSArray *videosSearchResults;

@property(nonatomic,assign) int searchOption;
//@property(nonatomic,assign) int protocolCategoryCount;
//@property(nonatomic,assign) int topicsCategoryCount;
//@property(nonatomic,assign) int videoCategoryCount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withRevealBlock:(RevealBlock)revealBlock;
-(void)closeSubView;
-(void) getSelectedCategories;
-(void) getSearchResults;
-(void) anyWords;
-(void) allWords;
-(void) exactPhrase;

@end
