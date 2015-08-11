//
//  SelectCategoriesViewController.h
//  ProtocolPedia
//
//   7/9/10.


#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"


@interface SelectCategoriesViewController : BaseTableViewController {
    UIView *viewHeader;
//	NSMutableArray *protocolCategories;
	NSString *categoryType;
	BOOL setClear;
//	IBOutlet UITableView *categoryTable;
}

//@property(nonatomic,retain) NSMutableArray *protocolCategories;
@property(nonatomic,assign) BOOL setClear;
@property(nonatomic,retain) NSString *categoryType;
//@property(nonatomic,retain) IBOutlet UITableView *categoryTable;

-(void)setAll;

@end
