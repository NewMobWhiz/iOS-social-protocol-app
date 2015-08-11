//
//  LeftMenuViewCell.m
//  ProtocolPedia
//
//  20/02/14.


#import "LeftMenuViewCell.h"

@implementation LeftMenuViewCell

@synthesize leftMenuImageView, leftMenuTitle;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        if (self.accessoryView) {
            self.accessoryView.hidden = YES;
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    if (selected == YES) {
        if (self.accessoryView) {
            self.accessoryView.hidden = NO;
        }
    }
    else if (selected == NO){
        if (self.accessoryView) {
            self.accessoryView.hidden = YES;
        }
    }
    
}

@end
