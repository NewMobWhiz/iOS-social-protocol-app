//
//  PPHomeViewController.h
//  ProtocolPedia
//


#import <UIKit/UIKit.h>
#import "PPAppDelegate.h"
#import "SlidingTabsControl.h"
#import "MxoSettingTextField.h"

#import "PPAbstractViewController.h"
//admob
#import "GADBannerView.h"
#import "StoreKit/StoreKit.h"

@interface PPHomeViewController : PPAbstractViewController <SlidingTabsControlDelegate>{
    
    SlidingTabsControl* tabs;
    IBOutlet UIView *_viewLogin;
    IBOutlet MxoSettingTextField *_login_username;
    IBOutlet MxoSettingTextField *_login_pass;

    IBOutlet UIView *_viewRegister;
    IBOutlet MxoSettingTextField *_register_firstname;
    IBOutlet MxoSettingTextField *_register_lastname;
    IBOutlet MxoSettingTextField *_register_email;
    IBOutlet MxoSettingTextField *_register_username;
    IBOutlet MxoSettingTextField *_register_password;
    BOOL _flagTerms;
    IBOutlet UIButton *_icnTerms;
    
    IBOutlet UIView *_viewTour;
    IBOutlet UIView *_viewSignUp;
    // admob
    GADBannerView *AbMob;
    //In app Purchase //
    BOOL areAdsRemoved;
    
@private
    RevealBlock _revealBlock;
}

@property (nonatomic,retain) PPAppDelegate *appDelegate;
@property (nonatomic) int tabIndex;
- (IBAction)openSignUpView:(id)sender;
- (IBAction)ClickHelp:(id)sender;

- (IBAction)touchFirstResponder:(id)sender;

- (IBAction)agreeTerms:(id)sender;

- (IBAction)loginClicked:(id)sender;

- (IBAction)signUpClicked:(id)sender;

- (IBAction)purchase;
- (IBAction)restore;
- (IBAction)tapsRemoveAdsButton;			

@end
