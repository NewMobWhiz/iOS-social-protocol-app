//
//  BaseViewController.h
//  ProtocolPedia
//
//   7/12/10.


#import <UIKit/UIKit.h>
#import "PPAppDelegate.h"
#import <iAd/iAd.h>



@interface BaseViewController : UIViewController < UITableViewDelegate, UITableViewDataSource, ADBannerViewDelegate> {

	PPAppDelegate *appDelegate;
	NSMutableArray *menuItems;
	IBOutlet UITableView *tableViewOutlet;
	ADBannerView *adView;
	BOOL bannerIsVisible;
	UIView	*navbarView;
	NSString *navbarTitle;	
	
	
}

@property (nonatomic,retain) NSMutableArray *menuItems;
@property (nonatomic,retain) PPAppDelegate *appDelegate;
@property (nonatomic,retain) IBOutlet UITableView *tableViewOutlet;
@property (nonatomic,assign) BOOL bannerIsVisible;
@property(nonatomic, retain) ADBannerView *adView;
@property (nonatomic, retain) UIView	*navbarView;
@property (nonatomic, retain) NSString *navbarTitle;

-(void) statusMessage:(NSNotification*)notification;
-(void) loadAd;

@end
