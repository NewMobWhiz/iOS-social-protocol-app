//
//  ProtocolWebViewController.h
//  ProtocolPedia
//
//   7/22/10.


#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TSPopoverController.h"

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#import "PPAbstractViewController.h"

@interface ProtocolWebViewController : PPAbstractViewController <MFMailComposeViewControllerDelegate>{

	IBOutlet UIWebView *myWebView;
	NSString *protocolText;
	NSString *selectedProtocolId;
	UIView *viewHeader;
    TSPopoverController *popShare;
    UIButton *btnShare;
    PPAppDelegate *appDelegate;
}

@property(nonatomic, retain) IBOutlet UIWebView *myWebView;
@property(nonatomic, retain) NSString *protocolText;
@property(nonatomic, retain) NSString *protocolName;
@property(nonatomic, retain) NSString *selectedProtocolId;

@end
