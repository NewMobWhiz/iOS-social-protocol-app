//
//  VideoListViewController.h
//  ProtocolPedia
//
//   7/29/10.


#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface VideoListViewController : BaseViewController {

	NSString *selectedCategory;

    UIView *viewHeader;
}


@property(nonatomic,retain) NSString *selectedCategory;


@end
