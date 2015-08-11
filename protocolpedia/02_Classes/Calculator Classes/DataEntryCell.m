
//
//   6/5/10.



#import "DataEntryCell.h"



@implementation DataEntryCell


@synthesize dataName;
@synthesize dataUnits;
@synthesize dataValue;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
	
		UILabel *nameTemp = [[UILabel alloc] initWithFrame:CGRectZero];
		self.dataName = nameTemp;
		self.dataName.textColor = [UIColor blackColor];
		self.dataName.font = [UIFont boldSystemFontOfSize:18.0];
		self.dataName.backgroundColor = [UIColor clearColor];
		self.dataName.adjustsFontSizeToFitWidth	= YES;
		self.dataName.minimumFontSize = 12;
		
		UILabel *dataUnitsTemp = [[UILabel alloc] initWithFrame:CGRectZero];
		self.dataUnits = dataUnitsTemp;
		self.dataUnits.textColor = [UIColor lightGrayColor];
		self.dataUnits.font = [UIFont boldSystemFontOfSize:18.0];
		self.dataUnits.backgroundColor = [UIColor clearColor];
		self.dataUnits.textAlignment = UITextAlignmentLeft;	
		self.dataUnits.adjustsFontSizeToFitWidth	= YES;
		self.dataUnits.minimumFontSize = 12;
		
		UITextField *valueTemp = [[UITextField alloc] initWithFrame:CGRectZero];
		self.dataValue = valueTemp;
		self.dataValue.textColor = [UIColor blueColor];
		self.dataValue.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
		self.dataValue.font = [UIFont boldSystemFontOfSize:18.0];
		self.dataValue.clearButtonMode = UITextFieldViewModeWhileEditing;
		self.dataValue.textAlignment = UITextAlignmentCenter;
		self.dataValue.borderStyle = UITextBorderStyleBezel;
		self.dataValue.clearsOnBeginEditing = YES;
		
		[self.contentView addSubview:self.dataName];			
		[self.contentView addSubview:self.dataUnits];
		[self.contentView addSubview:self.dataValue];

    }
    return self;
}


- (void)layoutSubviews {
	
	// total row height is 65,

	[super layoutSubviews];
	
	CGRect contentRect = self.contentView.bounds;
	
	CGFloat boundsX = contentRect.origin.x;
	CGRect frame;

	frame = CGRectMake(boundsX + 8, 2, 280, 20);
	self.dataName.frame = frame;

	frame = CGRectMake(boundsX + 120, 30, 200, 20);
	self.dataUnits.frame = frame;

	frame = CGRectMake(boundsX + 8, 25, 100, 30);
	self.dataValue.frame = frame;
	
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}







@end
