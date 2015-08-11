//
//  TSPopoverTouchDelegate.h
//


#import <UIKit/UIKit.h>


@protocol TSPopoverTouchesDelegate

@optional
- (void)view:(UIView*)view touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event;

@end