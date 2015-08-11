//
//  SlidingTabsTab.m
//

#import "SlidingTabsTab.h"
#import "PPAppDelegate.h"

@implementation SlidingTabsTab

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    
    PPAppDelegate *appDelegate = (PPAppDelegate*)[[UIApplication sharedApplication]delegate];
    UIColor *myColor = [UIColor colorWithRed:([[appDelegate.settings objectForKey:@"Red"] floatValue]/255.0) green:([[appDelegate.settings objectForKey:@"Green"] floatValue]/255.0) blue:([[appDelegate.settings objectForKey:@"Blue"] floatValue]/255.0) alpha:1.0];
    
    CGContextSetStrokeColorWithColor(context, myColor.CGColor);
    CGContextSetFillColorWithColor(context, myColor.CGColor);
    CGContextSetShadow(context, CGSizeMake (0, 0), 5.0);
    
    CGContextSaveGState(context);
    
    CGRect rrect = self.bounds;
    
    CGFloat radius = 0.0;
    CGFloat width = CGRectGetWidth(rrect);
    CGFloat height = CGRectGetHeight(rrect);

    CGContextMoveToPoint(context, 0, 0);
    CGContextAddArcToPoint(context, 5, 0, 5, 5, radius);
    CGContextAddLineToPoint(context, 5, height);
    CGContextAddLineToPoint(context, width-5, height);
    CGContextAddLineToPoint(context, width-5, radius);
    CGContextAddArcToPoint(context, width-radius, 0, width, 0, radius);
    CGContextAddLineToPoint(context, 0, 0);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextRestoreGState(context);
}




@end
