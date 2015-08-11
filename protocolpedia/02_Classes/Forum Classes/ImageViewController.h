//
//  ImageViewController.h
//  ProtocolPedia
//
//   9/17/10.


#import <UIKit/UIKit.h>
#import "BaseViewController.h"


@interface ImageViewController : BaseViewController {
	IBOutlet UIWebView *thisWebview;
	NSString *imageURLString;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	
}

@property (nonatomic,retain) IBOutlet UIWebView *thisWebview;
@property (nonatomic,retain) NSString *imageURLString;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
