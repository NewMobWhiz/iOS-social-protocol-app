//
//  ProtocolCategoryViewCell.m
//  ProtocolPedia
//
//  20/02/14.


#import "ProtocolCategoryViewCell.h"

@implementation ProtocolCategoryViewCell

@synthesize protocolCategoryImageView, protocolCategoryTitleLabel, protocolCategoryDescriptionLabel;

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
