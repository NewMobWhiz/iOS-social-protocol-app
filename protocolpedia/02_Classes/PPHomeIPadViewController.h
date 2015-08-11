//
//  PPHomeIPadViewController.h
//  ProtocolPedia
//


#import <UIKit/UIKit.h>
#import "PPAppDelegate.h"
#import "SlidingTabsControl.h"
#import "MxoSettingTextField.h"

@interface PPHomeIPadViewController : UIViewController <SlidingTabsControlDelegate>{
    UIView *viewHeader;
    PPAppDelegate *appDelegate;
    SlidingTabsControl* tabs;
    BOOL _flagTerms;
    
    IBOutlet MxoSettingTextField *_login_username;
    IBOutlet MxoSettingTextField *_login_pass;
    
    IBOutlet MxoSettingTextField *_register_firstname;
    IBOutlet MxoSettingTextField *_register_lastname;
    IBOutlet MxoSettingTextField *_register_email;
    IBOutlet MxoSettingTextField *_register_username;
    IBOutlet MxoSettingTextField *_register_password;
    
    IBOutlet UIView *_viewLogin;
    IBOutlet UIView *_viewRegister;
    IBOutlet UIView *_viewTour;
    IBOutlet UIView *_viewSignUp;
    IBOutlet UIButton *_icnTerms;
@private
    RevealBlock _revealBlock;
}
@property (nonatomic,retain) PPAppDelegate *appDelegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withRevealBlock:(RevealBlock)revealBlock;
- (IBAction)agreeTerms:(id)sender;
- (IBAction)touchFirstResponder:(id)sender;
- (IBAction)openSignupView:(id)sender;
- (IBAction)loginClicked:(id)sender;
- (IBAction)signUpClicked:(id)sender;

@end
