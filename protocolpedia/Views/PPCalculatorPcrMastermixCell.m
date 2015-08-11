//
//  PPPcrMastermixCell.m
//  ProtocolPedia
//
//  05/03/14.


#import "PPCalculatorPcrMastermixCell.h"

@implementation PPCalculatorPcrMastermixCell

@synthesize name;
@synthesize stock;
@synthesize final;
@synthesize volume;


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
