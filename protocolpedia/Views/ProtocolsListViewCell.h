//
//  ProtocolsListViewCell.h
//  ProtocolPedia
//
//  21/02/14.


#import <UIKit/UIKit.h>

@interface ProtocolsListViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *protocolLabel;

@property (nonatomic, strong) IBOutlet UIImageView *starsImageView;

@property (nonatomic, strong) IBOutlet UIButton *favoriteButton;

@end
