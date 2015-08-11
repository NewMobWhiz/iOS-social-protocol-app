//
//  ThreadWebViewController.h
//  ProtocolPedia
//
//   9/28/10.


#import <UIKit/UIKit.h>
#import "PPAbstractViewController.h"

@interface ThreadWebViewController : PPAbstractViewController <UIWebViewDelegate> {

	IBOutlet UIWebView *threadWebview;
	NSString *threadId;
    UIView *viewHeader;
}

@property(nonatomic,retain)  IBOutlet UIWebView *threadWebview;
@property(nonatomic,retain) NSString *threadId;
@property (nonatomic,retain) NSMutableArray *menuItems;
@property (nonatomic, retain) NSString *threadTitle;

-(void) addThread:(id)sender;
-(void) reloadTable:(NSNotification*)notification;
-(void) createWebView;

@end
