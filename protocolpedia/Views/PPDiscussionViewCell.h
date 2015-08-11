//
//  PPDiscussionViewCell.h
//  ProtocolPedia
//
//  26/03/14.


#import <UIKit/UIKit.h>

@interface PPDiscussionViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *discussionImageView;
@property (nonatomic, strong) IBOutlet UILabel *discussionTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *discussionDescriptionLabel;

@end
