//
//  ForumRootViewController.h
//  ProtocolPedia
//
//   7/16/10.


#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "GetForumDiscussions.h"
#import "PPAppDelegate.h"

@interface ForumRootViewController : BaseViewController  {
    UIView *viewHeader;
	GetForumDiscussions *getForumDiscussions;
@private
    RevealBlock _revealBlock;
}

@property(nonatomic,retain) GetForumDiscussions *getForumDiscussions;
-(void)closeSubView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withRevealBlock:(RevealBlock)revealBlock;
-(void) getForumDiscussionsMethod:(id)sender;
-(void) getForumDiscussionsComplete:(NSNotification *)notification;

@end
