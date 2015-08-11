//
//  PCRMastermixViewController.h
//  ProtocolPedia
//
//   9/3/10.


#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"


@interface PCRMastermixViewController : BaseTableViewController <UITextFieldDelegate> {

	NSMutableArray *myValues;
	
    UIView *viewHeader;
}

@property(nonatomic,retain) NSMutableArray *myValues;

-(void)calculateValues;
-(void) loadInfo:(id)sender;

@end
