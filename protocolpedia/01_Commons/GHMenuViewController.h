//
// GHMenuViewController.h
//

#import <Foundation/Foundation.h>
@class GHRevealViewController;

@interface GHMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    UIView *_vMask;
}

@property (nonatomic, strong) UIView *vMask;

- (id)initWithSidebarViewController:(GHRevealViewController *)sidebarVC
                      withSearchBar:(UISearchBar *)searchBar
                        withHeaders:(NSArray *)headers
                    withControllers:(NSArray *)controllers
                      withCellInfos:(NSArray *)cellInfos;

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath
                    animated:(BOOL)animated
              scrollPosition:(UITableViewScrollPosition)scrollPosition;
-(void)reloadTableView;

@end