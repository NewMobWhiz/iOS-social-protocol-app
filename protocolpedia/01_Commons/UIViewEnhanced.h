//
//  UIViewEnhanced.h
//


#import <Foundation/Foundation.h>


@interface UIView (Enhanced)

- (id)firstResponder;

- (BOOL)findAndResignFirstResponder;

- (CGRect)frameInView:(UIView *)parentView;

/**
 * Apply background to view's layer
 */
- (void)applyBackground:(NSString *)backgroundName;
- (void)applyBackground:(NSString *)backgroundName roundCorner:(CGFloat)radius;

/**
 * Apply texture to view's layer
 */
- (void)applyTexture:(NSString *)textureName;
- (void)applyTexture:(NSString *)textureName roundCorner:(CGFloat)radius;

/**
 * Round corner of an UIView with specific radius
 */
- (void)roundCorner:(CGFloat)radius;

@end
