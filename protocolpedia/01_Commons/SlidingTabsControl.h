//
//  SlidingTabsControl.h
//

#import <UIKit/UIKit.h>
#import "SlidingTabsTab.h"

@class SlidingTabsControl;
@protocol SlidingTabsControlDelegate;

@interface SlidingTabsControl : UIView {
    SlidingTabsTab* _tab;
    NSMutableArray* _buttons;
    NSObject <SlidingTabsControlDelegate> *_delegate;
}
-(void)refreshColor;
/**
 * Setup the tabs
 */
- (id) initWithTabCount:(NSUInteger)tabCount
                   delegate:(NSObject <SlidingTabsControlDelegate>*)slidingTabsControlDelegate;
- (void)touchUpInsideActionWithNoButton;

@end

@protocol SlidingTabsControlDelegate

- (UILabel*) labelFor:(SlidingTabsControl*)slidingTabsControl atIndex:(NSUInteger)tabIndex;

@optional
- (void) touchUpInsideTabIndex:(NSUInteger)tabIndex;
- (void) touchDownAtTabIndex:(NSUInteger)tabIndex;
@end
