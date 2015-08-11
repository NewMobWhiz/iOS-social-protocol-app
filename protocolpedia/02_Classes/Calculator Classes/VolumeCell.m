
//
//   6/5/10.



#import "VolumeCell.h"



@implementation VolumeCell


@synthesize name;
@synthesize value;
@synthesize values;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
	
		UILabel *nameTemp = [[UILabel alloc] initWithFrame:CGRectZero];
		self.name = nameTemp;
		self.name.textColor = [UIColor blackColor];
		self.name.font = [UIFont boldSystemFontOfSize:18.0];
		self.name.backgroundColor = [UIColor clearColor];	


		UITextField *valueTemp = [[UITextField alloc] initWithFrame:CGRectZero];
		self.value = valueTemp;
		self.value.textColor = [UIColor blueColor];
		self.value.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
		self.value.font = [UIFont boldSystemFontOfSize:18.0];
		self.value.clearButtonMode = UITextFieldViewModeWhileEditing;
		self.value.textAlignment = UITextAlignmentCenter;
		self.value.borderStyle = UITextBorderStyleRoundedRect;

		
		[self.contentView addSubview:self.name];			
		[self.contentView addSubview:self.value];

    }
    return self;
}


- (void)layoutSubviews {
	
	// total row height is 65,

	[super layoutSubviews];
	
	CGRect contentRect = self.contentView.bounds;
	
	CGFloat boundsX = contentRect.origin.x;
	CGRect frame;

	frame = CGRectMake(boundsX + 8,11, 200, 25);
	self.name.frame = frame;

	frame = CGRectMake(boundsX + 200, 11, 80, 25);
	self.value.frame = frame;

	

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}







@end
