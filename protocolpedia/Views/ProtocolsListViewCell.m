//
//  ProtocolsListViewCell.m
//  ProtocolPedia
//
//  21/02/14.


#import "ProtocolsListViewCell.h"

@implementation ProtocolsListViewCell

@synthesize protocolLabel, favoriteButton, starsImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProtocolsListViewCell" owner:self options:nil];
        //cell = [[ProtocolsListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        self = (ProtocolsListViewCell*) [nib objectAtIndex:0];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
