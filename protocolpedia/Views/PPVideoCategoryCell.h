//
//  PPVideoCategoryCell.h
//  ProtocolPedia
//
//  06/03/14.


#import <UIKit/UIKit.h>

@interface PPVideoCategoryCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *videoCategoryImageView;
@property (nonatomic, strong) IBOutlet UILabel *videoCategoryTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *videoCategoryDescriptionLabel;

@end
