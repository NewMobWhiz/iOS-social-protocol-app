//
//  PPVideoCategoryCell.m
//  ProtocolPedia
//
//  06/03/14.


#import "PPVideoCategoryCell.h"

@implementation PPVideoCategoryCell

@synthesize videoCategoryTitleLabel, videoCategoryDescriptionLabel, videoCategoryImageView;

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
