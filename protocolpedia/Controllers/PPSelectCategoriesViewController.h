//
//  PPSelectCategoriesViewController.h
//  ProtocolPedia
//
//  25/06/14.


#import "PPAbstractViewController.h"

@interface PPSelectCategoriesViewController : PPAbstractViewController

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;

@property(nonatomic,assign) BOOL setClear;
@property(nonatomic,retain) NSString *categoryType;

-(void)setAll;

@end
