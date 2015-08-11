
//
//   6/5/10.



#import "PCRMastermixCell.h"



@implementation PCRMastermixCell


@synthesize name;
@synthesize stockLabel;
@synthesize finalLabel;
@synthesize volumeLabel;
@synthesize stock;
@synthesize final;
@synthesize volume;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
	
		UILabel *nameTemp = [[UILabel alloc] initWithFrame:CGRectZero];
		self.name = nameTemp;
		self.name.textColor = [UIColor blackColor];
		self.name.font = [UIFont boldSystemFontOfSize:14.0];
		self.name.backgroundColor = [UIColor clearColor];
		
		UILabel *stockLabelTemp = [[UILabel alloc] initWithFrame:CGRectZero];
		self.stockLabel = stockLabelTemp;
		self.stockLabel.textColor = [UIColor lightGrayColor];
		self.stockLabel.font = [UIFont boldSystemFontOfSize:14.0];
		self.stockLabel.backgroundColor = [UIColor clearColor];
		self.stockLabel.text = @"stock";
		self.stockLabel.textAlignment = UITextAlignmentCenter;	

		UILabel *finalLabelTemp = [[UILabel alloc] initWithFrame:CGRectZero];
		self.finalLabel = finalLabelTemp;
		self.finalLabel.textColor = [UIColor lightGrayColor];
		self.finalLabel.font = [UIFont boldSystemFontOfSize:14.0];
		self.finalLabel.backgroundColor = [UIColor clearColor];
		self.finalLabel.text = @"final";
		self.finalLabel.textAlignment = UITextAlignmentCenter;	

		UILabel *volumeLabelTemp= [[UILabel alloc] initWithFrame:CGRectZero];
		self.volumeLabel = volumeLabelTemp;
		self.volumeLabel.textColor = [UIColor lightGrayColor];
		self.volumeLabel.font = [UIFont boldSystemFontOfSize:14.0];
		self.volumeLabel.backgroundColor = [UIColor clearColor];
		self.volumeLabel.numberOfLines = 2;
		self.volumeLabel.textAlignment = UITextAlignmentCenter;
		self.volumeLabel.text = [NSString stringWithFormat:@"Mastermix   (%cl)",181];	
		
		UILabel *volumeTemp = [[UILabel alloc] initWithFrame:CGRectZero];
		self.volume = volumeTemp;
		self.volume.textColor = [UIColor magentaColor];
		self.volume.font = [UIFont boldSystemFontOfSize:18.0];
		self.volume.backgroundColor = [UIColor clearColor];
		self.volume.textAlignment = UITextAlignmentCenter;
		
		UITextField *stockTemp = [[UITextField alloc] initWithFrame:CGRectZero];
		self.stock = stockTemp;
		self.stock.textColor = [UIColor blueColor];
		self.stock.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
		self.stock.font = [UIFont boldSystemFontOfSize:16.0];
		self.stock.clearButtonMode = UITextFieldViewModeWhileEditing;
		self.stock.textAlignment = UITextAlignmentCenter;
		self.stock.borderStyle = UITextBorderStyleRoundedRect;  // UITextBorderStyleBezel;
		
		UITextField *finalTemp = [[UITextField alloc] initWithFrame:CGRectZero];
		self.final = finalTemp;
		self.final.textColor = [UIColor blueColor];
		self.final.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
		self.final.font = [UIFont boldSystemFontOfSize:16.0];
		self.final.clearButtonMode = UITextFieldViewModeWhileEditing;	
		self.final.textAlignment = UITextAlignmentCenter;
		self.final.borderStyle = UITextBorderStyleRoundedRect; // UITextBorderStyleBezel;
		
		[self.contentView addSubview:self.name];			
//		[self.contentView addSubview:self.stockLabel];
//		[self.contentView addSubview:self.finalLabel];
//		[self.contentView addSubview:self.volumeLabel];
		[self.contentView addSubview:self.stock];
		[self.contentView addSubview:self.final];
		[self.contentView addSubview:self.volume];


    }
    return self;
}


- (void)layoutSubviews {
	
	// total row height is 45,

	[super layoutSubviews];
	
	CGRect contentRect = self.contentView.bounds;
	
	CGFloat boundsX = contentRect.origin.x;
	CGRect frame;

	frame = CGRectMake(boundsX + 8, 2, 200, 14);
	self.name.frame = frame;

//	frame = CGRectMake(boundsX + 4, 25, 80, 10);
//	self.stockLabel.frame = frame;
//
//	frame = CGRectMake(boundsX + 110, 25,80, 10);
//	self.finalLabel.frame = frame;
//	
//	frame = CGRectMake(boundsX + 220, 2, 80, 40);
//	self.volumeLabel.frame = frame;	
	
	frame = CGRectMake(boundsX + 4, 17, 80, 25);
	self.stock.frame = frame;
	
	frame = CGRectMake(boundsX + 110, 17, 80, 25);
	self.final.frame = frame;
	
	frame = CGRectMake(boundsX + 230, 13, 60, 25);
	self.volume.frame = frame;
	

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}







@end
