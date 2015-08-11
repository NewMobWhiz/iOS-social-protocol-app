//
//  AboutViewController.h
//  ProtocolPedia
//
//   7/16/10.


#import <UIKit/UIKit.h>
#import "PPAbstractViewController.h"
#import "PPAppDelegate.h"

@interface AboutViewController : PPAbstractViewController{
    UIBarButtonItem *gobackBarItem;

}

@property(nonatomic,retain) IBOutlet UILabel *versionLabel;

@end
