//
//  GHSidebarMenuCell.m
//

#import "GHMenuCell.h"


#pragma mark -
#pragma mark Constants
NSString const *kSidebarCellTextKey = @"CellText";
NSString const *kSidebarCellImageKey = @"CellImage";

#pragma mark -
#pragma mark Implementation
@implementation GHMenuCell

#pragma mark Memory Management
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		self.clipsToBounds = YES;
		
		UIView *bgView = [[UIView alloc] init];
		bgView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];
		self.selectedBackgroundView = bgView;
		
		self.imageView.contentMode = UIViewContentModeCenter;
		
		self.textLabel.font = [UIFont fontWithName:@"Century Gothic" size:([UIFont systemFontSize] * 1.2f)];
		self.textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		self.textLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
		self.textLabel.textColor = [UIColor colorWithRed:(196.0f/255.0f) green:(204.0f/255.0f) blue:(218.0f/255.0f) alpha:1.0f];
        self.textLabel.backgroundColor = [UIColor clearColor];
		
		UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(20.0f, 49.0f, 240, 1.0f)];
        if ([UIScreen mainScreen].bounds.size.height > 480) {
            bottomLine.frame = CGRectMake(20.0f, 59.0f, 240, 1.0f);
        }
		bottomLine.backgroundColor = [UIColor colorWithRed:(40.0f/255.0f) green:(47.0f/255.0f) blue:(61.0f/255.0f) alpha:1.0f];
//        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//            bottomLine.frame = CGRectMake(20.0f, 74.0f, 240, 1.0f);
//        }
		[self addSubview:bottomLine];
	}
	return self;
}

#pragma mark UIView
- (void)layoutSubviews {
	[super layoutSubviews];
    if ([UIScreen mainScreen].bounds.size.height > 480) {
        self.textLabel.frame = CGRectMake(70.0f, 0.0f, 200.0f, 60.0f);
        self.imageView.frame = CGRectMake(20.0f, 10.0f, 40.0f, 40.0f);
    }
	else{
        self.textLabel.frame = CGRectMake(70.0f, 0.0f, 200.0f, 50.0f);
        self.imageView.frame = CGRectMake(20.0f, 5.0f, 40.0f, 40.0f);
    }
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        self.textLabel.frame = CGRectMake(70.0f, 0.0f, 200.0f, 75.0f);
//        self.imageView.frame = CGRectMake(20.0f, 17.0f, 40.0f, 40.0f);
//    }
}

@end
