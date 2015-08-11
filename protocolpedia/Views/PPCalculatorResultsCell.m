//
//  PPCalculatorResultsCell.m
//  ProtocolPedia
//
//  04/03/14.


#import "PPCalculatorResultsCell.h"

@implementation PPCalculatorResultsCell

@synthesize result, resultsName, resultUnits;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
