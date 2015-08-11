//
//  InfoViewController.h
//  ProtocolPedia
//
//   9/5/10.


#import <UIKit/UIKit.h>
#import "BaseViewController.h"


@interface InfoViewController : BaseViewController {
	
	IBOutlet UITextView *thisTextView;
	NSString *thisString;

}

@property(nonatomic,retain) IBOutlet UITextView *thisTextView;
@property(nonatomic,retain) NSString *thisString;

@end
