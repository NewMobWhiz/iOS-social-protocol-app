//
//  ForumCategoriesViewController.h
//  ProtocolPedia
//
//   7/16/10.


#import <UIKit/UIKit.h>
#import "BaseViewController.h"


@interface ForumCategoriesViewController : BaseViewController {

	NSString *parentId;
    UIView *viewHeader;

}

@property(nonatomic,retain) NSString *parentId;
@property(nonatomic,retain) UIView *viewHeader;

@end
