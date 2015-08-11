
//
//   6/5/10.



#import "ResultsCell.h"



@implementation ResultsCell


@synthesize resultsName;
@synthesize result;
@synthesize resultUnits;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
	
		UILabel *nameTemp = [[UILabel alloc] initWithFrame:CGRectZero];
		self.resultsName = nameTemp;
		self.resultsName.textColor = [UIColor blackColor];
		self.resultsName.font = [UIFont boldSystemFontOfSize:18.0];
		self.resultsName.backgroundColor = [UIColor clearColor];	
		self.resultsName.adjustsFontSizeToFitWidth	= YES;
		self.resultsName.minimumFontSize = 12;
		
		UILabel *resultTemp = [[UILabel alloc] initWithFrame:CGRectZero];
		self.result = resultTemp;
		self.result.textColor = [UIColor magentaColor];
		self.result.font = [UIFont boldSystemFontOfSize:18.0];
		self.result.backgroundColor = [UIColor clearColor];
		self.result.textAlignment = UITextAlignmentCenter;	
		self.result.adjustsFontSizeToFitWidth	= YES;
		self.result.minimumFontSize = 12;

		UILabel *resultUnitsTemp = [[UILabel alloc] initWithFrame:CGRectZero];
		self.resultUnits = resultUnitsTemp;
		self.resultUnits.textColor = [UIColor lightGrayColor];
		self.resultUnits.font = [UIFont boldSystemFontOfSize:18.0];
		self.resultUnits.backgroundColor = [UIColor clearColor];
		self.resultUnits.textAlignment = UITextAlignmentLeft;
		self.resultUnits.adjustsFontSizeToFitWidth	= YES;
		self.resultUnits.minimumFontSize = 12;	

			
		[self.contentView addSubview:self.resultsName];			
		[self.contentView addSubview:self.result];
		[self.contentView addSubview:self.resultUnits];

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
	self.resultsName.frame = frame;

	frame = CGRectMake(boundsX + 120, 30,200, 20);
	self.resultUnits.frame = frame;
	
	frame = CGRectMake(boundsX + 8, 25, 100, 30);
	self.result.frame = frame;


	
	

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}







@end
