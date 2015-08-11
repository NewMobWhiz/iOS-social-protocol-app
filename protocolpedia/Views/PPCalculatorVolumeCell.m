//
//  PPCalculatorVolumeCell.m
//  ProtocolPedia
//
//  05/03/14.


#import "PPCalculatorVolumeCell.h"

@implementation PPCalculatorVolumeCell

@synthesize name;
@synthesize value;
@synthesize values;

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
