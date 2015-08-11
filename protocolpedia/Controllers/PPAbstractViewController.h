//
//  PPAbstractViewController.h
//  ProtocolPedia
//
//  06/04/14.


#import <UIKit/UIKit.h>
#import "PPAppDelegate.h"
#define APPDELEAGTE (PPAppDelegate *)[UIApplication sharedApplication].delegate
@interface PPAbstractViewController : UIViewController {
    PPAppDelegate* delegate;
}

- (void)setTitleImage:(UIImage *)titleImage;

- (void)setBackButton:(UIImage *)normalImage;

- (void)setLeftBarButton:(UIImage *)normalImage;

- (void)setRightBarButton:(UIImage *)normalImage;

- (void)setRightBarButtonWithString:(NSString *)rightTextString;

- (IBAction)onBackButton:(id)sender;

- (IBAction)onLeftBarButton:(id)sender;

- (IBAction)onRightBarButton:(id)sender;

@end
