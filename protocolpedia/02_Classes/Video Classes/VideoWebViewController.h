//
//  VideoWebViewController.h
//  ProtocolPedia
//
//   7/29/10.


#import <UIKit/UIKit.h>
#import "PPAbstractViewController.h"


@interface VideoWebViewController : PPAbstractViewController 

@property(nonatomic,retain) IBOutlet UIWebView *videoWebView;
@property(nonatomic,retain) NSString *selectedVideoId;

@end
