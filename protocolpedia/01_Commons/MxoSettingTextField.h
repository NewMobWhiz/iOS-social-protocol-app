//
//  MxoSettingTextField.h
//

#import <UIKit/UIKit.h>

@interface MxoSettingTextField : UITextField {
    __strong NSString *_keyTextField;
    @protected
    UIEdgeInsets _resizeBackground;
}
@property (strong, nonatomic) NSString *keyTextField;
@property (assign, nonatomic) UIEdgeInsets resizeBackground;

@end