//
//  UnitSelectionViewController.h
//  ProtocolPedia
//
//   9/5/10.


#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "PPAppDelegate.h"

@interface UnitSelectionViewController : BaseTableViewController {
	NSString *currentSelection;
	NSString *keyValue;
    UIView *viewHeader;
}

@property(nonatomic,retain) NSString *currentSelection;
@property(nonatomic,retain) NSString *keyValue;

@end
