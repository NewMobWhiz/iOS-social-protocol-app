//
//  PPMainViewController.h
//  ProtocolPedia
//
//   9/7/14.


#import <UIKit/UIKit.h>

@interface PPMainViewController : UIViewController <UITabBarDelegate> {
    NSMutableArray *controllers;
    IBOutlet UIView *tabViewContainner;
}

@end
