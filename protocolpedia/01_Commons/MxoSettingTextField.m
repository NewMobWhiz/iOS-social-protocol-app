//
//  MxoSettingTextField.m
//

#import "MxoSettingTextField.h"
#import <QuartzCore/QuartzCore.h>

@interface MxoSettingTextField () {
}

- (void)_init;

/**
 * Return inner size where content will be placed
 */
- (CGRect)_innerRectForBound:(CGRect)bounds;

@end

@implementation MxoSettingTextField

@synthesize resizeBackground=_resizeBackground;


#pragma mark - Class's constructors
- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
if (self) {
		[self _init];
	}
	return self;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		[self _init];
    }
    return self;
}

#pragma mark - Class's properties
- (void) setResizeBackground:(UIEdgeInsets)resizeBackground {
    UIImage *background = [self background];
    [self setBackground:[background resizableImageWithCapInsets:resizeBackground]];
}

#pragma mark - Class's override methods
- (CGRect)editingRectForBounds:(CGRect)bounds {
	return [self _innerRectForBound:bounds];
}
- (CGRect)placeholderRectForBounds:(CGRect)bounds {
	return [self _innerRectForBound:bounds];
}
- (CGRect)textRectForBounds:(CGRect)bounds {
	return [self _innerRectForBound:bounds];
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    //	if (action == @selector(cut:)) return NO;
    //	else if (action == @selector(copy:)) return NO;
    //    else if (action == @selector(paste:)) return NO;
    //	else if (action == @selector(select:)) return NO;
    //	else if (action == @selector(selectAll:)) return NO;
    
    if (action == @selector(paste:)) return NO;
    
    return [super canPerformAction:action withSender:sender];
}


#pragma mark - Class's private methods
- (void)_init {
    UIImage *background = [self background];
    if (background) {
        [self setBorderStyle:UITextBorderStyleNone];
        [self setBackground:[background resizableImageWithCapInsets:UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f)]];
    }
}
- (CGRect)_innerRectForBound:(CGRect)bounds {
	
	CGRect rect = CGRectMake(bounds.origin.x + 10, bounds.origin.y, bounds.size.width - 10, bounds.size.height);
    if ([_keyTextField isEqualToString:@"register"]) {
        rect = CGRectMake(bounds.origin.x + 30, bounds.origin.y, bounds.size.width - 30, bounds.size.height);
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
	return CGRectInset(rect, 0 , 0);
}

@end
