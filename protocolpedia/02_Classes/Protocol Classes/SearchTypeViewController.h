//
//  SearchTypeViewController.h
//  ProtocolPedia
//
//   8/30/10.


#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"


@interface SearchTypeViewController : BaseTableViewController {

	NSString *searchType;
    UIView *viewHeader;
}

@property(nonatomic,retain) NSString *searchType;

@end
